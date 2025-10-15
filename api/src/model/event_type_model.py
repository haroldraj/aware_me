from typing import Optional
from sqlmodel import Field, SQLModel, UniqueConstraint


class EventType(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    eventType: str
    eventValue: str
    description: str

    __table_args__ = (
        UniqueConstraint("eventType", "eventValue",
                         "description", name="event_type_unique"),
    )
