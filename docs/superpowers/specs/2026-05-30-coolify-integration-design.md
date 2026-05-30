# Design: Coolify-Ready Stateless App

## Overview
Enable the application to be deployed on Coolify by pointing to its public repository and using Docker Compose. The design focuses on "Zero-Config" in Coolify while allowing local development flexibility.

## Proposed Changes

### 1. `docker-compose.yaml`
Update the compose file to explicitly define ports and environment variables that Coolify can detect.

```yaml
services:
  web:
    build: .
    container_name: stateless-app
    restart: always
    ports:
      - "${PORT:-80}:80"
    environment:
      - PORT=80
      - SITE_NAME=${SITE_NAME:-Timezone Web App}
      - PRIMARY_COLOR=${PRIMARY_COLOR:-#1a73e8}
```
*   **Port Mapping:** Maps `${PORT}` from the environment (defaulting to 80) to the container's port 80.
*   **Environment Variables:** Defines `SITE_NAME` and `PRIMARY_COLOR` with default values. Coolify will parse these and show them in its "Environment Variables" tab.
*   **Internal Port:** Explicitly sets `PORT=80` inside the container to match the mapping and `Dockerfile` default.

### 2. `README.md`
Update the README to reflect the improved Coolify deployment steps.

## Verification Plan

### Automated Tests
*   No existing automated tests were found. I will add a simple health check test or a basic script to verify the app starts and responds.

### Manual Verification
1.  **Local (Direct):** Run `./run_local.sh` and verify access at `http://localhost:8081`.
2.  **Local (Docker):** Run `docker-compose up --build` and verify access at `http://localhost:80` (or `http://localhost:8081` if `PORT=8081` is set in `.env`).
3.  **Coolify Simulation:** Verify that `docker-compose config` produces the expected output with default values.

---

Spec written. Please review it and let me know if you want to make any changes before we start writing out the implementation plan.
