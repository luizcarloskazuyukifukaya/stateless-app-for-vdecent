# Coolify Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable the application to be deployed on Coolify by pointing to its public repository and using Docker Compose, while maintaining local development compatibility.

**Architecture:** Update `docker-compose.yaml` with explicit port mapping and environment variable defaults that Coolify can detect. Update `README.md` with deployment instructions. Add a health check script for verification.

**Tech Stack:** Docker, Docker Compose, FastAPI, Python.

---

### Task 1: Update Docker Compose Configuration

**Files:**
- Modify: `docker-compose.yaml`

- [ ] **Step 1: Update `docker-compose.yaml` with explicit ports and environment variables**

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

- [ ] **Step 2: Verify `docker-compose config`**

Run: `docker-compose config`
Expected: The output should show the resolved configuration with default values (PORT 80, SITE_NAME, etc.).

- [ ] **Step 3: Commit**

```bash
git add docker-compose.yaml
git commit -m "feat: enhance docker-compose for Coolify auto-detection"
```

### Task 2: Add Verification Health Check Script

**Files:**
- Create: `scripts/verify_deployment.sh`

- [ ] **Step 1: Create the verification script**

```bash
#!/bin/bash
set -e

PORT=${1:-80}
URL="http://localhost:$PORT"

echo "Checking $URL..."
if curl -s -f "$URL" > /dev/null; then
    echo "Success: App is responding at $URL"
else
    echo "Failure: App is NOT responding at $URL"
    exit 1
fi
```

- [ ] **Step 2: Make it executable**

Run: `chmod +x scripts/verify_deployment.sh`

- [ ] **Step 3: Commit**

```bash
git add scripts/verify_deployment.sh
git commit -m "test: add deployment verification script"
```

### Task 3: Update Documentation

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update Coolify deployment section in `README.md`**

```markdown
### Coolify

This application is optimized for **Zero-Config** deployment on **Coolify**:

1. Create a new **Application** in Coolify.
2. Select **Docker Compose** as the build pack.
3. Coolify will automatically detect the `SITE_NAME` and `PRIMARY_COLOR` environment variables from the `docker-compose.yaml` file.
4. In the **Domains** field, enter your domain (e.g., `https://your-domain.com`).
5. Deploy!
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: update Coolify deployment instructions in README"
```

### Task 4: Final Verification

- [ ] **Step 1: Verify local run (non-docker)**

Run: `./run_local.sh` (Wait for it to start)
Run: `./scripts/verify_deployment.sh 8081`
Expected: Success.

- [ ] **Step 2: Verify docker run**

Run: `docker-compose up -d --build`
Run: `./scripts/verify_deployment.sh 80`
Expected: Success.

- [ ] **Step 3: Clean up**

Run: `docker-compose down`
