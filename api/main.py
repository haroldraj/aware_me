from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def welcome(name: str = "Harold"):
    return {"message": f"Hello {name}"}
