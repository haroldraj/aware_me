from datetime import datetime
from typing import Optional
from sqlmodel import Field, SQLModel

class EventInfo(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    eventType: str
    lastTimeUsed: datetime
    receivedBytes: str
    transferedBytes: str

class AppUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime
