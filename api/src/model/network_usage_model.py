
from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from sqlmodel import Field, SQLModel, UniqueConstraint


class NetworkUsageRequest(BaseModel):
    userId: str
    packageName: str
    totalReceivedBytes: int
    totalTransferredBytes: int
    startDate: datetime
    endDate: datetime


class NetworkUsage(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: str
    packageName: str
    totalReceivedBytes: int
    totalTransferredBytes: int
    startDate: datetime
    endDate: datetime

    __table_args__ = (
        UniqueConstraint("userId", "packageName", "startDate", name="network_usage_unique"),
    )
