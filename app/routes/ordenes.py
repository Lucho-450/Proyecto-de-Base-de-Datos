from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List
from app.db import get_connection

router = APIRouter(prefix="/ordenes", tags=["Órdenes de Compra (CRUD Complejo)"])

class ItemOrden(BaseModel):
    id_producto: int
    cantidad_solicitada: int
    costo_unitario: float

class NuevaOrden(BaseModel):
    id_proveedor: int
    fecha_emision: str
    fecha_entrega_prevista: str
    items: List[ItemOrden]

@router.post("/")
def crear_orden_completa(orden: NuevaOrden):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id_proveedor FROM proveedor WHERE id_proveedor = %s AND estado = 'ACTIVO';", (orden.id_proveedor,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Proveedor no encontrado o inactivo")

            cur.execute("""
                INSERT INTO orden_compra (fecha_emision, fecha_entrega_prevista, estado, id_proveedor)
                VALUES (%s, %s, 'PENDIENTE', %s) RETURNING id_orden;
            """, (orden.fecha_emision, orden.fecha_entrega_prevista, orden.id_proveedor))
            id_orden = cur.fetchone()["id_orden"]

            for item in orden.items:
                cur.execute("""
                    INSERT INTO detalle_orden_compra (cantidad_solicitada, costo_unitario, id_orden, id_producto)
                    VALUES (%s, %s, %s, %s);
                """, (item.cantidad_solicitada, item.costo_unitario, id_orden, item.id_producto))

        conn.commit()
        return {"mensaje": "Orden creada correctamente", "id_orden": id_orden}
    except HTTPException:
        conn.rollback()
        raise
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        conn.close()

@router.get("/")
def listar_ordenes_detalladas():
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT oc.id_orden, oc.fecha_emision, oc.estado, p.razon_social AS proveedor,
                       pr.nombre AS producto, doc.cantidad_solicitada, doc.costo_unitario
                FROM orden_compra oc
                JOIN proveedor p ON oc.id_proveedor = p.id_proveedor
                JOIN detalle_orden_compra doc ON oc.id_orden = doc.id_orden
                JOIN producto pr ON doc.id_producto = pr.id_producto
                ORDER BY oc.id_orden DESC;
            """)
            return cur.fetchall()
    finally:
        conn.close()
