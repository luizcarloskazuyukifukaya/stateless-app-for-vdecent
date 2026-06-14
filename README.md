# Stateless App for V-Decent

A simple, lightweight stateless web application built with FastAPI. This project serves a static `index.html` page and is designed to be easily containerized and deployed.

## Features

- **FastAPI Backend:** High-performance Python framework for building APIs.
- **Static Content Hosting:** Serves static files from the `static/` directory.
- **Stateless Design:** No persistent state within the application, making it ideal for scalable cloud deployments.
- **Dockerized:** Includes a `Dockerfile` and `docker-compose.yaml` for easy environment setup and deployment.

## V-Decent Compatibility
This application is designed for V-Decent deployment.

Include:
- Docker Compose file: `docker-compose.yaml`
- No host port mappings
- Public-facing service name: `web`
- Internal exposed port: `80`
- Health endpoint: `/health`
- Environment variable configuration
- Stateful/stateless classification: **Stateless (Pattern A)**

## Project Structure

```text
.
├── docker-compose.yaml     # V-Decent compatible manifest
├── Dockerfile              # Docker image configuration
├── .env.example            # Environment variable template
├── main.py                 # FastAPI application entry point
├── requirements.txt        # Python dependencies
├── README.md               # This file
├── docs/
│   └── vdecent-handover.md # Handover notes for V-Decent Operator
└── static/                 # Directory for static assets
    └── index.html          # Main landing page
```

## Getting Started

### Prerequisites

- Python 3.9+
- Docker (optional, for containerized execution)

### Running Locally (Bare-metal Python)

Run the application directly using Python. The script will automatically find an available port starting at 8081.

```bash
./run_local.sh
```

### Running Locally (Docker Compose)

Run the application locally using Docker Compose. The script uses `docker-compose.dev.yaml` to map ports and automatically finds an available port starting at 8081.

```bash
./run_docker_local.sh
```

### 3. Test Health
```bash
curl http://localhost:8081/health
```

## Production Environment Variables
- `PORT`: Internal port for the application (default: 80).
- `SITE_NAME`: Custom title for the application.
- `PRIMARY_COLOR`: Hex code for the primary UI color.

## Deployment Source
Repository URL: https://github.com/v-decent/stateless-app-for-vdecent
Branch: docker-network-enhancement
Repository visibility: Private (ensure Deploy Key is configured)

## V-Decent Application Manager Registration Notes
Public-facing service: `web`
Production URL: https://stateless-app.v-decent.org
Internal services that must not be exposed: None

## Troubleshooting
- **Health Check Failing:** Ensure the application starts within the timeout period. Check logs using `docker compose logs`.
- **Environment Variables:** Verify that all required variables are set in the V-Decent Application Manager.

## License
MIT
