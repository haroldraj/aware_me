from typing import Optional
from fastapi import FastAPI
from sqlmodel import Field, Session, SQLModel, create_engine, select
from pydantic import BaseModel
from datetime import datetime


class AppUsageData(BaseModel):
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime


class EventData(BaseModel):
    name: str


class AppUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime


app = FastAPI()

engine = create_engine(
    "postgresql://aware_me_user:aware_me_password@localhost:5435/aware_me_db")

SQLModel.metadata.create_all(engine)


@app.get("/")
def welcome(name: str = "Harold"):
    return {"message": f"Hello {name}"}


@app.post("/test")
def post_test(name: str = "Test"):
    return {"data": f"Connction etablished with {name}"}


@app.post("/app_usage_data")
def app_usage_data(appusagedata: list[AppUsageData]):
    with Session(engine) as session:
        for data in appusagedata:
            record = AppUsage(
                userId=data.userId,
                packageName=data.packageName,
                appName=data.appName,
                usage=data.usage,
                startDate=data.startDate,
                endDate=data.endDate,
                lastForegroundDate=data.lastForegroundDate
            )
            session.add(record)
        session.commit()

    return {"message": f"{len(appusagedata)} records saved successfully."}


@app.post("/event_data")
def event_data(eventdata: list[EventData]):
    return eventdata
