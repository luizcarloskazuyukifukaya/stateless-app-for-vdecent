from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import uvicorn
import os

app = FastAPI()

# Setup templates
templates = Jinja2Templates(directory="static")

@app.get("/", response_class=HTMLResponse)
async def get_index(request: Request):
    # Get customization from environment variables
    site_name = os.environ.get("SITE_NAME", "Timezone Web App")
    primary_color = os.environ.get("PRIMARY_COLOR", "#1a73e8")
    
    return templates.TemplateResponse(
        request=request,
        name="index.html",
        context={
            "site_name": site_name,
            "primary_color": primary_color
        }
    )

if __name__ == "__main__":
    # Get port from environment variable for deployment flexibility
    port = int(os.environ.get("PORT", 80))
    uvicorn.run(app, host="0.0.0.0", port=port)
