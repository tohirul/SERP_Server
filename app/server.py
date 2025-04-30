from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def index():
    return {
        "name": "SERP Scraper",
        "version": "1.0.0",
        "message": "Server is running",
    }
