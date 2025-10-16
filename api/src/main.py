
from fastapi import FastAPI, HTTPException, Depends, Header
import os
from src.model.app_usage_model import AppUsageRequest
from src.model.custom_usage_model import CustomUsageRequest
from src.model.event_info_model import EventInfoRequest
from src.model.network_usage_model import NetworkUsageRequest
from src.service.save_data_service import SaveDataService
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("API_KEY")

app = FastAPI()

SaveDataService.save_event_type_data()


def verify_api_key(api_key: str = Header(...)):
    if api_key != API_KEY:
        raise HTTPException(
            status_code=401, detail="Invalid or missing API Key")


@app.get("/")
def welcome(name: str = "Harold"):
    return {"message": f"Hello {name}"}


@app.post("/test")
def post_test(name: str = "Test", _: None = Depends(verify_api_key)):
    return {"data": f"Connection etablished with {name}"}


@app.post("/app_usage")
def save_app_usage_data(appusagerequest: list[AppUsageRequest], _: None = Depends(verify_api_key)):
    return SaveDataService.save_app_usage_data(appusagerequest)


@app.post("/event_info")
def save_event_data(eventInfoRequest: list[EventInfoRequest], _: None = Depends(verify_api_key)):
    return SaveDataService.save_event_data(eventInfoRequest)


@app.post("/custom_usage")
def save_custom_usage_data(customUsageRequest: list[CustomUsageRequest], _: None = Depends(verify_api_key)):
    return SaveDataService.save_custom_usage_data(customUsageRequest)


@app.post("/network_usage")
def save_network_usage_data(networkUsageRequest: list[NetworkUsageRequest], _: None = Depends(verify_api_key)):
    return SaveDataService.save_netork_usage_data(networkUsageRequest)
