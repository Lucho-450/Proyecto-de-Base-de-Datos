-- Columna semi-estructurada JSONB para atributos variables por categoría
ALTER TABLE producto
ADD COLUMN IF NOT EXISTS atributos_extra JSONB DEFAULT '{}'::jsonb;

-- Índice GIN para búsquedas rápidas dentro del JSONB
CREATE INDEX IF NOT EXISTS idx_producto_atributos_gin ON producto USING GIN (atributos_extra);

-- Datos de ejemplo heterogéneos
UPDATE producto
SET atributos_extra = '{"lactosa": true, "refrigeracion_c": 4, "marca": "Laive"}'::jsonb
WHERE id_producto = 1;

UPDATE producto
SET atributos_extra = '{"origen": "Mar peruano", "congelado": false, "alergenos": ["pescado"]}'::jsonb
WHERE id_producto = 4;

-- Busqueda de productos que contienen un atributo especifico
EXPLAIN ANALYZE
SELECT id_producto, nombre, atributos_extra
FROM producto
WHERE atributos_extra @> '{"lactosa": true}'::jsonb;
