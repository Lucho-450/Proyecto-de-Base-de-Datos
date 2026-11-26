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

-- 5. Tabla PROVEEDOR
INSERT INTO proveedor (ruc, razon_social, direccion, telefono, correo, estado)
VALUES ('20100094212', 'Laive S.A.', 'Av. Nicolás Arriola 740, La Victoria', '014175000', 'ventas@laive.com.pe', 'ACTIVO'),
       ('20100035121', 'Otto Kunz S.A.C.', 'Av. Los Frutales 450, Ate', '013495600', 'pedidos@ottokunz.com.pe', 'ACTIVO'),
       ('20512345678', 'Panificadora Del Sur S.A.C.', 'Jr. Huancavelica 320, Cercado de Lima', '014281234', 'contacto@panificadorasur.pe', 'INACTIVO'),
       ('20567891234', 'Pesquera Mar Azul S.A.', 'Av. Néstor Gambetta 1250, Callao', '015772200', 'ventas@maraazul.com.pe', 'ACTIVO'),
       ('20601234567', 'Agrícola Frutas del Valle E.I.R.L.', 'Mercado Mayorista de Frutas, La Victoria', '998112233', 'frutasdelvalle@gmail.com', 'ACTIVO');

-- 6. Tabla PRODUCTO_PROVEEDOR
INSERT INTO producto_proveedor (codigo_proveedor, costo_referencia, plazo_entrega, id_proveedor, id_producto)
VALUES ('LAI-001', 9.50, 2, 1, 1),
('OTK-014', 12.80, 3, 2, 2),
('PDS-007', 2.80, 1, 3, 3),
('PMA-032', 14.00, 2, 4, 4),
('AFV-101', 5.20, 1, 5, 5);


-- 7. Tabla ORDEN_COMPRA
INSERT INTO orden_compra (fecha_emision, fecha_entrega_prevista, estado, id_proveedor)
VALUES ('2026-11-01', '2026-11-05', 'Aprobada', 1),
('2026-11-02', '2026-11-06', 'Pendiente', 2),
('2026-11-02', '2026-11-04', 'Pendiente', 3),
('2026-11-03', '2026-11-07', 'Recibida', 4),
('2026-11-03', '2026-11-05', 'Cancelada', 5);

UPDATE orden_compra SET estado = 'Recibida' WHERE id_orden = 2;
