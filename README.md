# Proyecto-de-Base-de-Datos

INTEGRANTES:

1. Luis Fernando Llosa Romero 

2.Juan  Fernando  Incacutipa  Choque

3.Katheryne Flor Aimituma Ccallo

4.Rocio Nicole Manzanedo Punto

# ERP Minimarket — Base de Datos en PostgreSQL

Proyecto académico de base de datos relacional y semiestructurada para un **ERP de Minimarket**, implementado en **PostgreSQL 19** sobre la base de datos `minimarket_db`.

## 1. Alcance y Modelo de Datos

El sistema cubre el ciclo operativo de inventario y abastecimiento mediante **18 tablas** interconectadas con claves primarias, claves foráneas y restricciones `CHECK`:

* **Catálogos y maestros:** `categoria`, `unidad_medida`, `producto`, `regla_reposicion`, `proveedor`, `producto_proveedor`, `ubicacion_almacen`, `tipo_movimiento`.
* **Compras y recepción:** `orden_compra`, `detalle_orden_compra`, `recepcion_mercaderia`, `detalle_recepcion`.
* **Control de inventario y movimientos:** `lote`, `existencia`, `movimiento_inventario`, `conteo_inventario`, `detalle_conteo`, `ajuste_inventario`.

### Reglas de integridad destacadas
* En `orden_compra`, los estados permitidos están restringidos a: `PENDIENTE`, `ENVIADA`, `RECIBIDA` y `CANCELADA`.
* Las relaciones entre tablas mantienen la integridad referencial (`FOREIGN KEY`) y las restricciones de dominio (`CHECK`) en estados, cantidades y fechas.

## 2. Estructura del Repositorio

* `sql/01_ddl_tablas.sql`: Creación de las 18 tablas, llaves primarias, llaves foráneas y restricciones `CHECK` en `minimarket_db`.
* `sql/02_dml_datos.sql`: Poblamiento inicial de datos y actualizaciones de prueba, con `TRUNCATE ... RESTART IDENTITY CASCADE` para permitir reejecuciones limpias sin duplicados ni desfase de secuencias.
* `sql/03_indices_optimizacion.sql`: Creación de índices (`CREATE INDEX IF NOT EXISTS`) y consultas con `EXPLAIN ANALYZE` para evaluar el rendimiento.
* `sql/04_modulo_jsonb.sql`: Implementación de atributos flexibles en `JSONB` y creación de índice `GIN` sobre `producto`.
* `README.md`: Documentación general del proyecto y evidencias de optimización.

## 3. Orden de Ejecución en PostgreSQL 19

1. Crear y conectarse a la base de datos `minimarket_db`.
2. Ejecutar `sql/01_ddl_tablas.sql` para generar las 18 tablas y sus restricciones.
3. Ejecutar `sql/02_dml_datos.sql` para cargar los registros base.
4. Ejecutar `sql/03_indices_optimizacion.sql` para aplicar los índices y validar planes de ejecución.
5. Ejecutar `sql/04_modulo_jsonb.sql` para habilitar el módulo `JSONB`.

## 4. Optimización y Pruebas de Rendimiento (`EXPLAIN ANALYZE`)

Se midió el plan de ejecución y el tiempo de respuesta de consultas sobre `movimiento_inventario` antes y después de crear los índices en `03_indices_optimizacion.sql`.

### 4.1. Prueba ANTES de crear los índices
<img width="1067" height="742" alt="Captura de pantalla 2026-11-26 000850" src="https://github.com/user-attachments/assets/512cfebb-655f-44cf-97ae-5ac9fdc2ecfc" />


* **Plan observado:** Indica aquí si usó `Seq Scan` u otro nodo y cuál fue el `Execution Time` inicial.

### 4.2. Prueba DESPUÉS de crear los índices
<img width="1077" height="750" alt="Captura de pantalla 2026-11-26 001403" src="https://github.com/user-attachments/assets/e0518922-55c4-4345-9947-388e154864fe" />


* **Plan observado:** Indica aquí el plan obtenido tras indexar (por ejemplo, `Index Scan` o `Index Only Scan`) y el nuevo `Execution Time`.

### 4.3. Índices creados y justificación

| Índice | Tabla | Columnas | Justificación técnica |
| :--- | :--- | :--- | :--- |
| `idx_movimiento_producto_fecha` | `movimiento_inventario` | `id_producto`, `fecha DESC` | Optimiza filtros por producto y ordenamientos cronológicos descendentes. |
| `idx_lote_vencimiento` | `lote` | `fecha_vencimiento` | Facilita búsquedas y controles por fecha de caducidad de lotes. |
| `idx_existencia_lote_ubicacion` | `existencia` | `id_lote`, `id_ubicacion` | Mejora consultas de disponibilidad agrupadas o filtradas por lote y ubicación. |

## 5. Módulo `JSONB` (`04_modulo_jsonb.sql`)

Se añadió la columna `atributos_extra` de tipo `JSONB` (con valor por defecto `'{}'::jsonb`) en la tabla `producto` para almacenar datos semiestructurados y variables según la categoría sin modificar el esquema relacional fijo. Además, se creó el índice invertido `idx_producto_atributos_gin` (`USING GIN`) para acelerar búsquedas dentro del `JSONB` y se cargaron atributos de ejemplo en los productos con `id_producto = 1` (datos de lácteos y refrigeración) e `id_producto = 4` (origen, estado de congelado y alérgenos). Al ejecutar el script en pgAdmin, **Messages** confirmó la ejecución (`Query returned successfully`) y **Data Output** mostró los registros actualizados con sus objetos `JSONB`.
