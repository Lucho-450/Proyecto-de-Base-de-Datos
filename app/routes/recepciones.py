from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.db import get_connection

router = APIRouter(prefix="/recepciones", tags=["Recepción de Mercadería (ACID)"])

class RecepcionRequest(BaseModel):
    id_orden: int
    fecha_recepcion: str
    id_lote: int
    id_producto: int
    id_ubicacion: int
    cantidad_recibida: int
    cantidad_aceptada: int
    cantidad_rechazada: int
    observaciones: str = ""

@router.post("/procesar")
def procesar_recepcion_acid(data: RecepcionRequest):
    conn = get_connection()
    conn.autocommit = False
    try:
        with conn.cursor() as cur:
            cur.execute("BEGIN;")

            cur.execute("""
                INSERT INTO recepcion_mercaderia (id_orden, fecha_recepcion, estado, observaciones)
                VALUES (%s, %s, 'COMPLETADA', %s) RETURNING id_recepcion;
            """, (data.id_orden, data.fecha_recepcion, data.observaciones))
            id_recepcion = cur.fetchone()["id_recepcion"]

            cur.execute("""
                INSERT INTO detalle_recepcion (id_recepcion, id_lote, cantidad_recibida, cantidad_aceptada, cantidad_rechazada)
                VALUES (%s, %s, %s, %s, %s);
            """, (id_recepcion, data.id_lote, data.cantidad_recibida, data.cantidad_aceptada, data.cantidad_rechazada))

            cur.execute("""
                UPDATE existencia
                SET cantidad_disponible = cantidad_disponible + %s
                WHERE id_lote = %s AND id_ubicacion = %s;
            """, (data.cantidad_aceptada, data.id_lote, data.id_ubicacion))

            if cur.rowcount == 0:
                cur.execute("""
                    INSERT INTO existencia (id_lote, id_ubicacion, cantidad_disponible, cantidad_reservada)
                    VALUES (%s, %s, %s, 0);
                """, (data.id_lote, data.id_ubicacion, data.cantidad_aceptada))

            cur.execute("""
                INSERT INTO movimiento_inventario (id_tipo_movimiento, id_producto, id_lote, id_ubicacion, cantidad, referencia_operacion, observaciones)
                VALUES (1, %s, %s, %s, %s, %s, %s);
            """, (data.id_producto, data.id_lote, data.id_ubicacion, data.cantidad_aceptada, f"REC-{id_recepcion}", data.observaciones))

            cur.execute("UPDATE orden_compra SET estado = 'RECIBIDA' WHERE id_orden = %s;", (data.id_orden,))

            cur.execute("COMMIT;")
        return {"mensaje": "Recepción procesada con éxito (ACID)", "id_recepcion": id_recepcion}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=f"Transacción revertida (ROLLBACK): {str(e)}")
    finally:
        conn.close()
