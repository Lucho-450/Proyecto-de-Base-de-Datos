from fastapi import FastAPI
from app.routes import ordenes

app = FastAPI(title="API Minimarket - Bases de Datos")
app.include_router(ordenes.router)
