-- 1. Tabla CATEGORIA
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

-- 2. Tabla UNIDAD_MEDIDA
CREATE TABLE unidad_medida (
    id_unidad SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    abreviatura VARCHAR(10) NOT NULL
);

-- 3. Tabla PRODUCTO
CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255) NULL,
    precio_referencia NUMERIC(10,2) NOT NULL CHECK (precio_referencia >= 0),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    id_categoria INTEGER NOT NULL REFERENCES categoria(id_categoria),
    id_unidad INTEGER NOT NULL REFERENCES unidad_medida(id_unidad)
);

-- 4. Tabla REGLA_REPOSICION
CREATE TABLE regla_reposicion (
    id_regla SERIAL PRIMARY KEY,
    stock_minimo INTEGER NOT NULL CHECK (stock_minimo >= 0),
    stock_maximo INTEGER NOT NULL CHECK (stock_maximo >= stock_minimo),
    punto_reposicion INTEGER NOT NULL CHECK (punto_reposicion >= 0),
    id_producto INTEGER UNIQUE NOT NULL REFERENCES producto(id_producto) ON DELETE CASCADE
);

-- 5. Tabla PROVEEDOR
CREATE TABLE proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    ruc VARCHAR(11) UNIQUE NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

-- 6. Tabla PRODUCTO_PROVEEDOR
CREATE TABLE producto_proveedor (
    id_producto_proveedor SERIAL PRIMARY KEY,
    codigo_proveedor VARCHAR(50) NOT NULL,
    costo_referencia NUMERIC(10,2) NOT NULL CHECK (costo_referencia >= 0),
    plazo_entrega INTEGER NOT NULL CHECK (plazo_entrega > 0),
    id_proveedor INTEGER NOT NULL REFERENCES proveedor(id_proveedor) ON DELETE CASCADE,
    id_producto INTEGER NOT NULL REFERENCES producto(id_producto) ON DELETE CASCADE,
    UNIQUE (id_proveedor, id_producto)
);

-- 7. Tabla ORDEN_COMPRA
CREATE TABLE orden_compra (
    id_orden SERIAL PRIMARY KEY,
    fecha_emision DATE NOT NULL,
    fecha_entrega_prevista DATE NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('PENDIENTE', 'ENVIADA', 'RECIBIDA', 'CANCELADA')),
    id_proveedor INTEGER NOT NULL REFERENCES proveedor(id_proveedor),
    CHECK (fecha_entrega_prevista >= fecha_emision)
);

-- 8. Tabla DETALLE_ORDEN_COMPRA
CREATE TABLE detalle_orden_compra (
    id_detalle_orden SERIAL PRIMARY KEY,
    cantidad_solicitada INTEGER NOT NULL CHECK (cantidad_solicitada > 0),
    costo_unitario NUMERIC(10,2) NOT NULL CHECK (costo_unitario >= 0),
    id_orden INTEGER NOT NULL REFERENCES orden_compra(id_orden) ON DELETE CASCADE,
    id_producto INTEGER NOT NULL REFERENCES producto(id_producto),
    UNIQUE (id_orden, id_producto)
);

-- 9. Tabla UBICACION_ALMACEN
CREATE TABLE ubicacion_almacen (
    id_ubicacion SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    tipo_ubicacion VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

-- 10. Tabla LOTE
CREATE TABLE lote (
    id_lote SERIAL PRIMARY KEY,
    numero_lote VARCHAR(20) UNIQUE NOT NULL,
    fecha_fabricacion DATE NULL,
    fecha_vencimiento DATE NOT NULL,
    id_producto INTEGER NOT NULL REFERENCES producto(id_producto),
    CHECK (fecha_fabricacion IS NULL OR fecha_vencimiento > fecha_fabricacion)
);

-- 11. Tabla EXISTENCIA
CREATE TABLE existencia (
    id_existencia SERIAL PRIMARY KEY,
    id_lote INT NOT NULL REFERENCES lote(id_lote) ON DELETE CASCADE,
    id_ubicacion INT NOT NULL REFERENCES ubicacion_almacen(id_ubicacion),
    cantidad_disponible INT NOT NULL DEFAULT 0 CHECK (cantidad_disponible >= 0),
    cantidad_reservada INT NOT NULL DEFAULT 0 CHECK (cantidad_reservada >= 0)
);

-- 12. Tabla RECEPCION_MERCADERIA
CREATE TABLE recepcion_mercaderia (
    id_recepcion SERIAL PRIMARY KEY,
    id_orden INT NOT NULL REFERENCES orden_compra(id_orden),
    fecha_recepcion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL,
    observaciones VARCHAR(255) NULL
);
