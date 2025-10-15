from typing import Optional
from sqlmodel import Field, SQLModel, UniqueConstraint
from datetime import datetime
from pydantic import BaseModel


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

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "eventType",
                         "eventDate", "className", name="unique_event"),
    )
