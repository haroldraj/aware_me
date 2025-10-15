
from fastapi import FastAPI

from src.model.app_usage_model import AppUsageRequest
from src.model.custom_usage_model import CustomUsageRequest
from src.model.event_info_model import EventInfoRequest
from src.model.network_usage_model import NetworkUsageRequest
from src.service.save_data_service import SaveDataService


app = FastAPI()

SaveDataService.save_event_type_data()


@app.get("/")
def welcome(name: str = "Harold"):
    return {"message": f"Hello {name}"}


@app.post("/test")
def post_test(name: str = "Test"):
    return {"data": f"Connction etablished with {name}"}


@app.post("/app_usage")
def save_app_usage_data(appusagerequest: list[AppUsageRequest]):
    return SaveDataService.save_app_usage_data(appusagerequest)


@app.post("/event_info")
def save_event_data(eventInfoRequest: list[EventInfoRequest]):
    return SaveDataService.save_event_data(eventInfoRequest)


@app.post("/custom_usage")
def save_custom_usage_data(customUsageRequest: list[CustomUsageRequest]):
    return SaveDataService.save_custom_usage_data(customUsageRequest)


@app.post("/network_usage")
def save_network_usage_data(networkUsageRequest: list[NetworkUsageRequest]):
    return SaveDataService.save_netork_usage_data(networkUsageRequest)
