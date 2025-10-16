from sqlmodel import Field, SQLModel, UniqueConstraint
from typing import Optional
from datetime import datetime
from pydantic import BaseModel


class AppUsageRequest(BaseModel):
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime


class AppUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    appName: str
    usage: int
    startDate: datetime
    endDate: datetime
    lastForegroundDate: datetime
#    createdAt: Optional[datetime] = Field(default=datetime.now)

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "startDate",
                         "endDate", "lastForegroundDate", name="unique_usage"),
    )
