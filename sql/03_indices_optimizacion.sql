-- 1. Prueba ANTES del índice
EXPLAIN ANALYZE
SELECT * FROM movimiento_inventario
WHERE id_producto = 1 AND fecha >= '2026-01-01';

-- 2. Creación de índices justificados
CREATE INDEX idx_movimiento_producto_fecha ON movimiento_inventario (id_producto, fecha DESC);
CREATE INDEX idx_lote_vencimiento ON lote (fecha_vencimiento);
CREATE INDEX idx_existencia_lote_ubicacion ON existencia (id_lote, id_ubicacion);

-- 3. Prueba DESPUÉS del índice
EXPLAIN ANALYZE
SELECT * FROM movimiento_inventario
WHERE id_producto = 1 AND fecha >= '2026-01-01';
