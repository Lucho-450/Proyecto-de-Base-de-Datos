from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Dict, Any
import json
from app.db import get_connection

router = APIRouter(prefix="/hibrido", tags=["Módulo Híbrido (JSONB)"])

class AtributosExtra(BaseModel):
    atributos: Dict[str, Any]

@router.put("/producto/{id_producto}/atributos")
def actualizar_atributos_jsonb(id_producto: int, payload: AtributosExtra):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE producto
                SET atributos_extra = atributos_extra || %s::jsonb
                WHERE id_producto = %s
                RETURNING id_producto, nombre, atributos_extra;
            """, (json.dumps(payload.atributos), id_producto))
            res = cur.fetchone()
            if not res:
                raise HTTPException(status_code=404, detail="Producto no encontrado")
        conn.commit()
        return res
    finally:
        conn.close()

@router.get("/productos/buscar")
def buscar_por_atributo(clave: str, valor: str):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id_producto, nombre, atributos_extra
                FROM producto
                WHERE atributos_extra ->> %s = %s;
            """, (clave, valor))
            return cur.fetchall()
    finally:
        conn.close()
