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
