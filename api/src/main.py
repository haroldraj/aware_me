
from typing import Optional
from datetime import datetime
from fastapi import FastAPI
from pydantic import BaseModel
from sqlmodel import Session, SQLModel, create_engine, Field
# from model.base_model import EventInfoRequest, AppUsageRequest
# from model.sql_model import EventInfo, AppUsage


class AppUsageRequest(BaseModel):
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime


class EventInfoRequest(BaseModel):
    userId: str
    packageName: str
    eventType: str
    eventDate: datetime
    className: str


class EventInfo(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    eventType: str
    eventDate: datetime
    className: str


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


@app.post("/app_usage")
def app_usage_data(appusagerequest: list[AppUsageRequest]):
    with Session(engine) as session:
        for data in appusagerequest:
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

    return {"message": f"{len(appusagerequest)} records saved successfully."}


@app.post("/event_info")
def event_data(eventInfoRequest: list[EventInfoRequest]):
    with Session(engine) as session:
        for data in eventInfoRequest:
            record = EventInfo(
                userId=data.userId,
                packageName=data.packageName,
                eventType=data.eventType,
                eventDate=data.eventDate,
                className=data.className
            )
            session.add(record)

        session.commit()

    return {"message": f"{len(eventInfoRequest)} records saved successfully."}
