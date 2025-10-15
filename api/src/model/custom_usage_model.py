from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from sqlmodel import Field, SQLModel, UniqueConstraint


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
