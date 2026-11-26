import csv
import io
from fastapi import APIRouter
from fastapi.responses import StreamingResponse
from app.db import get_connection

router = APIRouter(prefix="/reportes", tags=["Reportes y Exportación CSV"])

@router.get("/stock-por-categoria/csv")
def exportar_stock_categoria_csv(min_stock: int = 10):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT c.nombre AS categoria,
                       COUNT(DISTINCT p.id_producto) AS total_productos,
                       SUM(e.cantidad_disponible) AS stock_disponible_total,
                       SUM(e.cantidad_reservada) AS stock_reservado_total
                FROM categoria c
                JOIN producto p ON c.id_categoria = p.id_categoria
                JOIN lote l ON p.id_producto = l.id_producto
                JOIN existencia e ON l.id_lote = e.id_lote
                GROUP BY c.nombre
                HAVING SUM(e.cantidad_disponible) >= %s
                ORDER BY stock_disponible_total DESC;
            """, (min_stock,))
            rows = cur.fetchall()

        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(["categoria", "total_productos", "stock_disponible_total", "stock_reservado_total"])
        for r in rows:
            writer.writerow([r["categoria"], r["total_productos"], r["stock_disponible_total"], r["stock_reservado_total"]])

        output.seek(0)
        return StreamingResponse(
            iter([output.getvalue()]),
            media_type="text/csv",
            headers={"Content-Disposition": "attachment; filename=reporte_stock_categorias.csv"}
        )
    finally:
        conn.close()
