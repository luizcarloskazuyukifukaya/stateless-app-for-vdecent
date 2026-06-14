# V-Decent Deployment Handover

## Application Identity
Application name: Stateless App for V-Decent
Primary shortname: stateless-app
Production URL: https://stateless-app.v-decent.org
Developer group: V-Decent Team
GitHub account or organization: v-decent

## Deployment Source
Repository URL: https://github.com/v-decent/stateless-app-for-vdecent
Repository visibility: Private
Branch: docker-network-enhancement
Manifest file: docker-compose.yaml

## Service Exposure
| Service | Expose Publicly? | URL | Notes |
|---|---:|---|---|
| web | Yes | https://stateless-app.v-decent.org | Main FastAPI web service |

## Environment Variables for Production
```env
PORT=80
SITE_NAME=Timezone Web App
PRIMARY_COLOR=#1a73e8
```

## Health Check
Health endpoint: /health
Expected response: {"status": "ok"}
Startup time estimate: < 5 seconds

## Data Persistence
Application type: Stateless Application (Pattern A)
External storage: None
Docker volumes: None
Backup sidecar: None
Restore procedure: N/A

## Local Verification Evidence
Commands run:
- `docker compose config`
- `docker compose up --build -d`
- `curl -i http://localhost:8081/health`

Results:
- Manifest is valid.
- Container starts and health status becomes `healthy`.
- Health endpoint returns 200 OK.

Known limitations:
- None identified.

## Deployment Notes for V-Decent Operator
- This is a simple stateless FastAPI app.
- It uses `wget` in the Docker healthcheck, which is included in the base Python image.
