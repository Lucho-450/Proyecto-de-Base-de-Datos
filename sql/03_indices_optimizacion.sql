
-- 1. Eliminar los indices si ya existen
-- Esto permite repetir la prueba desde cero.
DROP INDEX IF EXISTS idx_movimiento_producto_fecha;
DROP INDEX IF EXISTS idx_lote_vencimiento;

-- 2. Prueba ANTES de crear los indices
EXPLAIN ANALYZE
SELECT *
FROM movimiento_inventario
WHERE id_producto = 1
AND fecha >= '2026-01-01';

EXPLAIN ANALYZE
SELECT *
FROM lote
WHERE fecha_vencimiento <= DATE '2026-12-31';

-- 3. Crear los indices
CREATE INDEX idx_movimiento_producto_fecha
ON movimiento_inventario (id_producto, fecha DESC);

CREATE INDEX idx_lote_vencimiento
ON lote (fecha_vencimiento);

-- 4. Prueba DESPUES de crear los indices
EXPLAIN ANALYZE
SELECT *
FROM movimiento_inventario
WHERE id_producto = 1
AND fecha >= '2026-01-01';

EXPLAIN ANALYZE
SELECT *
FROM lote
WHERE fecha_vencimiento <= DATE '2026-12-31';
