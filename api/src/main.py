
from typing import Optional
from datetime import datetime
from fastapi import FastAPI
from pydantic import BaseModel
from sqlmodel import Session, SQLModel, create_engine, Field, UniqueConstraint
from sqlalchemy.dialects.postgresql import insert
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


class CustomUsageRequest(BaseModel):
    userId: str
    packageName: str
    firstTimeStamp: datetime
    lastTimeStamp: datetime
    lastTimeUsed: datetime
    totalTimeInForeground: int


class CustomUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    firstTimeStamp: datetime
    lastTimeStamp: datetime
    lastTimeUsed: datetime
    totalTimeInForeground: int

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "firstTimeStamp", "lastTimeStamp",
                         "lastTimeUsed", "totalTimeInForeground", name="unique_custom"),
    )


class EventInfo(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    eventType: str
    eventDate: datetime
    className: str

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "eventType",
                         "eventDate", "className", name="unique_event"),
    )


class AppUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "startDate",
                         "endDate", "lastForegroundDate", name="unique_usage"),
    )


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
        stmt = insert(AppUsage).values([
            {
                "userId": data.userId,
                "packageName": data.packageName,
                "appName": data.appName,
                "usage": data.usage,
                "startDate": data.startDate,
                "endDate": data.endDate,
                "lastForegroundDate": data.lastForegroundDate,
            }
            for data in appusagerequest
        ])
        stmt = stmt.on_conflict_do_nothing(
            index_elements=["userId", "packageName",
                            "startDate", "endDate", "lastForegroundDate",]
        )
        result = session.exec(stmt)
        session.commit()

    inserted = result.rowcount or 0
    duplicates = len(appusagerequest) - inserted

    return {
        "message": f"{inserted} new records inserted successfully.",
        "duplicates_skipped": duplicates
    }


@app.post("/event_info")
def event_data(eventInfoRequest: list[EventInfoRequest]):
    with Session(engine) as session:
        stmt = insert(EventInfo).values([
            {
                "userId": d.userId,
                "packageName": d.packageName,
                "eventType": d.eventType,
                "eventDate": d.eventDate,
                "className": d.className
            } for d in eventInfoRequest
        ])
        stmt = stmt.on_conflict_do_nothing(
            index_elements=["userId", "packageName",
                            "eventType", "eventDate", "className",]
        )
        result = session.exec(stmt)
        session.commit()

    inserted = result.rowcount or 0
    duplicates = len(eventInfoRequest) - inserted

    return {
        "message": f"{inserted} new records inserted successfully.",
        "duplicates_skipped": duplicates
    }


@app.post("/custom_usage")
def custom_usage_Data(customUsageRequest: list[CustomUsageRequest]):
    with Session(engine) as session:
        stmt = insert(CustomUsage).values([
            {
                "userId": record.userId,
                "packageName": record.packageName,
                "firstTimeStamp": record.firstTimeStamp,
                "lastTimeStamp": record.lastTimeStamp,
                "lastTimeUsed": record.lastTimeUsed,
                "totalTimeInForeground": record.totalTimeInForeground
            } for record in customUsageRequest
        ])
        stmt = stmt.on_conflict_do_nothing(index_elements=["userId", "packageName", "firstTimeStamp", "lastTimeStamp",
                                                           "lastTimeUsed", "totalTimeInForeground"])
        result = session.exec(stmt)
        session.commit()

    inserted = result.rowcount or 0
    duplicates = len(customUsageRequest) - inserted

    return {
        "message": f"{inserted} new records inserted successfully.",
        "duplicates_skipped": duplicates
    }
