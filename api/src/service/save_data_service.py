
from sqlmodel import SQLModel, Session, create_engine
from sqlalchemy.dialects.postgresql import insert
from src.model.app_usage_model import AppUsage, AppUsageRequest
from src.model.custom_usage_model import CustomUsage, CustomUsageRequest
from src.model.event_info_model import EventInfo, EventInfoRequest
from src.model.event_type_model import EventType
from src.model.network_usage_model import NetworkUsage, NetworkUsageRequest
from src.resource.event_type_data import EVENT_TYPE_DATA
from src.resource.sql_engine import SQL_ENGINE_URL

engine = create_engine(SQL_ENGINE_URL)

SQLModel.metadata.create_all(engine)


class SaveDataService:

    @staticmethod
    def save_event_type_data():
        with Session(engine) as session:
            query = insert(EventType).values([
                {
                    "eventType": record["eventType"],
                    "eventValue": record["eventValue"],
                    "description": record["description"]
                } for record in EVENT_TYPE_DATA
            ])
            query = query.on_conflict_do_nothing(
                index_elements=["eventType", "eventValue", "description",])
            session.exec(query)
            session.commit()

    @staticmethod
    def save_app_usage_data(appusagerequest: list[AppUsageRequest]):
        with Session(engine) as session:
            query = insert(AppUsage).values([
                {
                    "userId": record.userId,
                    "packageName": record.packageName,
                    "appName": record.appName,
                    "usage": record.usage,
                    "startDate": record.startDate,
                    "endDate": record.endDate,
                    "lastForegroundDate": record.lastForegroundDate,
                }
                for record in appusagerequest
            ])
            query = query.on_conflict_do_nothing(
                index_elements=["userId", "packageName",
                                "startDate", "endDate", "lastForegroundDate",]
            )
            result = session.exec(query)
            session.commit()

        inserted = result.rowcount or 0
        duplicates = len(appusagerequest) - inserted

        return {
            "new_inserted": inserted,
            "duplicates_skipped": duplicates
        }

    @staticmethod
    def save_event_data(eventInfoRequest: list[EventInfoRequest]):
        with Session(engine) as session:
            query = insert(EventInfo).values([
                {
                    "userId": record.userId,
                    "packageName": record.packageName,
                    "eventType": record.eventType,
                    "eventDate": record.eventDate,
                    "className": record.className
                } for record in eventInfoRequest
            ])
            query = query.on_conflict_do_nothing(
                index_elements=["userId", "packageName",
                                "eventType", "eventDate", "className",]
            )
            result = session.exec(query)
            session.commit()

        inserted = result.rowcount or 0
        duplicates = len(eventInfoRequest) - inserted

        return {
            "new_inserted": inserted,
            "duplicates_skipped": duplicates
        }

    @staticmethod
    def save_custom_usage_data(customUsageRequest: list[CustomUsageRequest]):
        with Session(engine) as session:
            query = insert(CustomUsage).values([
                {
                    "userId": record.userId,
                    "packageName": record.packageName,
                    "firstTimeStamp": record.firstTimeStamp,
                    "lastTimeStamp": record.lastTimeStamp,
                    "lastTimeUsed": record.lastTimeUsed,
                    "totalTimeInForeground": record.totalTimeInForeground
                } for record in customUsageRequest
            ])
            query = query.on_conflict_do_nothing(index_elements=["userId", "packageName", "firstTimeStamp", "lastTimeStamp",
                                                                 "lastTimeUsed", "totalTimeInForeground"])
            result = session.exec(query)
            session.commit()

        inserted = result.rowcount or 0
        duplicates = len(customUsageRequest) - inserted

        return {
            "new_inserted": inserted,
            "duplicates_skipped": duplicates
        }

    @staticmethod
    def save_netork_usage_data(networkUsareRequest: list[NetworkUsageRequest]):
        with Session(engine) as session:
            query = insert(NetworkUsage).values([
                {
                    "userId": record.userId,
                    "packageName": record.packageName,
                    "totalReceivedBytes": record.totalReceivedBytes,
                    "totalTransferredBytes": record.totalTransferredBytes,
                    "startDate": record.startDate,
                    "endDate": record.endDate
                } for record in networkUsareRequest
            ])
            query = query.on_conflict_do_update(
                index_elements=["userId", "packageName", "startDate"],
                set_={
                    "totalReceivedBytes": query.excluded.totalReceivedBytes,
                    "totalTransferredBytes": query.excluded.totalTransferredBytes,
                    "endDate": query.excluded.endDate,
                })
            result = session.exec(query)
            session.commit()

        inserted = result.rowcount or 0

        return {
            "new_inserted": inserted,
        }
