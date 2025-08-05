from fastapi import FastAPI
from app.routes import api

app = FastAPI()

@app.get("/healthz")
def health_check():
    return {"status": "ok"}

app.include_router(api.router)
