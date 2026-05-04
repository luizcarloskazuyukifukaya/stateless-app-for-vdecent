from fastapi import FastAPI
from fastapi.responses import FileResponse
import uvicorn
import os

app = FastAPI()

# Path to the static directory
STATIC_DIR = os.path.join(os.path.dirname(__file__), "static")

@app.get("/")
async def get_index():
    return FileResponse(os.path.join(STATIC_DIR, "index.html"))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8081)
