from fastapi import FastAPI
from sqlmodel import Field, Session, SQLModel, create_engine, select

app = FastAPI()

#engine = create_engine("postgresql://localhost:5435/aware_me_db")

@app.get("/")
def welcome(name: str = "Harold"):
    return {"message": f"Hello {name}"}

@app.post("/appusagedata")
def app_usage_data(name: str = "Test"):
    return {"data": f"Connction etablished with {name}"}