-- 1. Tabla CATEGORIA
INSERT INTO categoria (nombre, descripcion, estado)
VALUES ('Lacteos', 'Derivados de la leche', 'ACTIVO'),
       ('Charcutería', 'Embutidos', 'INACTIVO'),
       ('Panadería', 'Postres y pan', 'INACTIVO'),
       ('Pescadería', 'Mariscos y pescado', 'ACTIVO'),
       ('Frutería', 'Frutas', 'ACTIVO');

-- 2. Tabla UNIDAD_MEDIDA
INSERT INTO unidad_medida (nombre, abreviatura)
VALUES ('Litros', 'lt'),
       ('Gramos', 'gr'),
       ('Kilogramos', 'kg'),
       ('Miligramos', 'mg'),
       ('Unidad', 'uni');

-- 3. Tabla PRODUCTO
INSERT INTO producto (codigo_barras, nombre, descripcion, precio_referencia, estado, id_categoria, id_unidad)
VALUES ('7751271010016', 'Leche Laive', 'Leche con lactosa', 12.00, 'ACTIVO', 1, 1),
       ('7750243000123', 'Chorizo Otto Kunz', 'Chorizo precocido', 16.00, 'INACTIVO', 2, 2),
       ('0012345678905', 'Ciabatta', 'Pan', 4.00, 'INACTIVO', 3, 3),
       ('5901234123457', 'Bonito', 'Pescado', 18.00, 'ACTIVO', 4, 4),
       ('4006381333931', 'Naranja de jugo', 'Fruta', 7.00, 'ACTIVO', 5, 5);

UPDATE producto SET precio_referencia = 15.00 WHERE id_unidad = 1;

-- 4. Tabla REGLA_REPOSICION
INSERT INTO regla_reposicion (stock_minimo, stock_maximo, punto_reposicion, id_producto)
VALUES (20, 100, 40, 1),
       (10, 50, 20, 2),
       (15, 60, 25, 3),
       (8, 40, 15, 4),
       (30, 150, 60, 5);

UPDATE regla_reposicion
SET stock_maximo = 200,
    punto_reposicion = 80
WHERE id_producto = 5;
