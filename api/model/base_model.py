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

class EventInfoRequest(BaseModel):
    userId: str
    packageName: str
    eventType: str
    lastTimeUsed: datetime
    receivedBytes: str
    transferedBytes: str
