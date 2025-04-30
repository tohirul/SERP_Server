from fastapi import FastAPI


app = FastAPI()


@app.get("/")
async def index():
    return {
        "success": True,
        "message": "API is working",
        "data": {
            "name": "SERP API SERVER",
            "version": "0.0.1",
            "description": "This is a simple API server for SERP API.",
        },
    }
