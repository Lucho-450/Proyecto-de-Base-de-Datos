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
