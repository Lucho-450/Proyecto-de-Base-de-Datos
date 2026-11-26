from fastapi import FastAPI
from app.routes import ordenes, recepciones, reportes

app = FastAPI(title="API Minimarket - Bases de Datos")
app.include_router(ordenes.router)
app.include_router(recepciones.router)
app.include_router(reportes.router)
