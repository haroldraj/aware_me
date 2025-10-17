
from pydantic import BaseModel

from src.model.app_usage_model import AppUsageRequest
from src.model.custom_usage_model import CustomUsageRequest
from src.model.event_info_model import EventInfoRequest
from src.model.network_usage_model import NetworkUsage


class AllUsageDataRequest(BaseModel):
    customUsageRequestList: list[CustomUsageRequest]
    eventInfoRequestList: list[EventInfoRequest]
    networkUsageRequestList: list[NetworkUsage]
