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
