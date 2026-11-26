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
* `sql/03_indices_optimizacion.sql`: Creación de índices (`CREATE INDEX`) y consultas con `EXPLAIN ANALYZE` para evaluar el rendimiento.
* `sql/04_modulo_jsonb.sql`: Implementación de atributos flexibles en `JSONB` y creación de índice `GIN` sobre `producto`.
* `README.md`: Documentación general del proyecto y evidencias de optimización.

## 3. Orden de Ejecución en PostgreSQL 19

1. Crear y conectarse a la base de datos `minimarket_db`.
2. Ejecutar `sql/01_ddl_tablas.sql` para generar las 18 tablas y sus restricciones.
3. Ejecutar `sql/02_dml_datos.sql` para cargar los registros base.
4. Ejecutar `sql/03_indices_optimizacion.sql` para aplicar los índices y validar planes de ejecución.
5. Ejecutar `sql/04_modulo_jsonb.sql` para habilitar el módulo `JSONB`.

## 4. Optimización y Pruebas de Rendimiento (EXPLAIN ANALYZE)

Se evaluó el comportamiento de dos índices mediante consultas ejecutadas antes y después de su creación. Para ello, se utilizó EXPLAIN ANALYZE en las tablas movimiento_inventario y lote.

### 4.1. Consulta de movimientos antes de crear el índice

Se evaluó la búsqueda de movimientos por producto y fecha.

<img width="890" height="743" alt="image" src="https://github.com/user-attachments/assets/dd59cf22-e5f6-417e-b2ba-164f3afc2ec7" />


- *Plan de ejecución:* Seq Scan.
- *Planning Time:* 0.216 ms.
- *Execution Time:* 0.028 ms.
- *Filas encontradas:* 2.

### 4.2. Consulta de lotes antes de crear el índice

Se evaluó la búsqueda de lotes según su fecha de vencimiento.

<img width="790" height="748" alt="image" src="https://github.com/user-attachments/assets/cbeed35d-11dc-490c-af7d-340484253871" />


- *Plan de ejecución:* Seq Scan.
- *Planning Time:* 0.171 ms.
- *Execution Time:* 0.026 ms.
- *Filas encontradas:* 3.

### 4.3. Consulta de movimientos después de crear el índice

Se repitió la misma consulta después de crear el índice idx_movimiento_producto_fecha.

<img width="947" height="752" alt="image" src="https://github.com/user-attachments/assets/b4e137f9-59b1-4f66-85fa-9064586baf5e" />


- *Plan de ejecución:* Seq Scan.
- *Planning Time:* 0.327 ms.
- *Execution Time:* 0.033 ms.
- *Filas encontradas:* 2.

### 4.4. Consulta de lotes después de crear el índice

Se repitió la misma consulta después de crear el índice idx_lote_vencimiento.

<img width="693" height="747" alt="image" src="https://github.com/user-attachments/assets/d9d4a9eb-9db8-467a-b2b1-6a59b7d0e335" />

- *Plan de ejecución:* Seq Scan.
- *Planning Time:* 0.236 ms.
- *Execution Time:* 0.020 ms.
- *Filas encontradas:* 3.

### 4.5. Índices creados y justificación

| Índice | Tabla | Columnas | Justificación técnica |
| :--- | :--- | :--- | :--- |
| idx_movimiento_producto_fecha | movimiento_inventario | id_producto, fecha DESC | Facilita las consultas que filtran movimientos por producto y fecha, y puede apoyar ordenamientos cronológicos descendentes. |
| idx_lote_vencimiento | lote | fecha_vencimiento | Facilita las consultas que filtran lotes por fecha de vencimiento. |

### 4.6. Análisis de resultados

En las pruebas realizadas, PostgreSQL utilizó Seq Scan en las cuatro ejecuciones, incluso después de crear los índices. Esto se debe a que las tablas contienen pocos registros y el planificador considera conveniente realizar un escaneo secuencial.

Los tiempos de ejecución fueron muy pequeños y presentaron variaciones entre las pruebas. Por ello, con el volumen de datos utilizado no se pudo comprobar una mejora de rendimiento atribuible a los índices. Sin embargo, estos permiten preparar la base de datos para consultas sobre un mayor volumen de información.
## 5. Módulo `JSONB` (`04_modulo_jsonb.sql`)

Se añadió la columna `atributos_extra` de tipo `JSONB` (con valor por defecto `'{}'::jsonb`) en la tabla `producto` para almacenar datos semiestructurados y variables según la categoría sin modificar el esquema relacional fijo. Además, se creó el índice invertido `idx_producto_atributos_gin` (`USING GIN`) para acelerar búsquedas dentro del `JSONB` y se cargaron atributos de ejemplo en los productos con `id_producto = 1` (datos de lácteos y refrigeración) e `id_producto = 4` (origen, estado de congelado y alérgenos). Al ejecutar el script en pgAdmin, **Messages** confirmó la ejecución (`Query returned successfully`) y **Data Output** mostró los registros actualizados con sus objetos `JSONB`.
