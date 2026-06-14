# V-Decent AI Coding Agent Project Prompt

Use this prompt when starting a new application project intended to run on **V-Decent Virtual Distributed Infrastructure**.

---

## Prompt to Give the AI Coding Agent

You are an expert full-stack application developer. Build this application so it can be developed, tested, registered, and deployed through **V-Decent Virtual Distributed Infrastructure**, also called **V-Decent**.

V-Decent is a distributed datacenter hosting environment that uses **Docker Compose**, **Cloudflare Tunnels**, **Coolify orchestration**, and the **V-Decent Application Manager**. The application must be compatible with V-Decent deployment rules from the beginning.

Your job is to create production-ready application code, repository structure, Docker configuration, environment-variable templates, local test instructions, and deployment handover notes.

---

## Application to Build

Replace the placeholders below before starting:

```text
Application name: <APP_NAME>
Primary shortname / subdomain: <APP_SHORTNAME>
Target production URL: https://<APP_SHORTNAME>.v-decent.org
Application type: <STATELESS | STATEFUL_EXTERNAL_DATA | STATEFUL_WITH_LIMITED_INTERNAL_DATA>
Main application purpose: <DESCRIBE_THE_APP>
Technology stack preference: <NODE/EXPRESS | NEXT.JS | PYTHON/FASTAPI | OTHER>
Primary exposed service/container: <SERVICE_NAME>
Internal application port: <PORT>
External storage required: <YES/NO>
Database required: <YES/NO>
Repository visibility: <PUBLIC | PRIVATE>
Git branch for deployment: <BRANCH_NAME>
```

---

## Non-Negotiable V-Decent Compatibility Rules

The repository must be compatible with V-Decent Application Manager and Coolify deployment.

### 1. Docker Compose Is Required

Create a file named exactly:

```text
docker-compose.yaml
```

Do not use a different file name such as `docker-compose.yml`, `compose.yaml`, or `docker-compose.prod.yaml` as the only deployment manifest.

The Docker Compose file must define every service needed by the application.

### 2. Do Not Use Host Port Mapping

Do **not** use host port mappings like this:

```yaml
ports:
  - "8080:80"
```

V-Decent handles ingress routing through Cloudflare Tunnels and the Coolify proxy. Services that need to receive external traffic must use `expose`, not `ports`.

Use this pattern:

```yaml
services:
  app:
    build: .
    restart: always
    expose:
      - "80"
    environment:
      - PORT=80
```

### 3. Exactly One Public-Facing Service Unless Specified Otherwise

Identify which service should be exposed by V-Decent Application Manager.

Most applications should expose only the main web/API container, for example:

```text
Expose: app -> https://<APP_SHORTNAME>.v-decent.org
Do not expose: db, redis, worker, backup-sidecar, internal services
```

If a service should not be reachable from the internet, its URL field must be left empty during V-Decent Application Manager registration.

### 4. Environment Variables Are Required

Use environment variables for runtime configuration. Provide:

```text
.env.example
```

The `.env.example` file must list all required variables with safe sample values or clear placeholders.

Never commit real production secrets.

Example:

```env
# App Configuration
PORT=80
SITE_NAME=Example V-Decent App
PRIMARY_COLOR=#1a73e8

# External Services
DATABASE_URL=postgres://user:password@db:5432/appdb
API_KEY=replace_me
```

Also provide a separate section in the README called **Production Environment Variables** explaining which values must be supplied to V-Decent Application Manager.

### 5. Health Checks Are Required

Add Docker health checks for services where possible, especially the main app and database.

Example for a web app:

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -qO- http://localhost:80/health || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 10
```

The application should expose a lightweight health endpoint:

```text
GET /health
```

The health endpoint should return HTTP 200 when the application is ready to receive traffic.

### 6. Persistent Data Rules

V-Decent is optimized for stateless applications, but some stateful patterns are allowed.

Choose one of these patterns:

#### Pattern A — Stateless Application

Use this when the app does not store persistent data inside the container or in V-Decent-managed storage.

Requirements:

```text
No local persistent data
No database volume
No uploads stored inside the container filesystem
All configuration through environment variables
```

#### Pattern B — Stateful Application with External Data

Use this when the app stores data outside V-Decent, such as AWS S3, Wasabi, another managed database, or another external storage system.

Requirements:

```text
External data location configured by environment variables
No assumption that container filesystem persists
Clear documentation of all external storage variables
```

#### Pattern C — Stateful Application with Internal Data, Supported with Limitation

Use this only when a database or persistent volume is included in Docker Compose.

Requirements:

```text
Map data to discrete Docker volumes
Document that database persistence is limited unless external backup is configured
Add database health checks
Do not expose the database service publicly
If backup is required, include a backup sidecar container and document backup/restore behavior
```

Example:

```yaml
services:
  app:
    build: .
    restart: always
    expose:
      - "80"
    environment:
      - PORT=80
      - DATABASE_URL=postgres://user:password@db:5432/appdb
    depends_on:
      db:
        condition: service_healthy
    networks:
      - app-network

  db:
    image: postgres:16-alpine
    restart: always
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=appdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d appdb"]
      interval: 5s
      timeout: 5s
      retries: 10
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  postgres_data:
```

---

## Required Repository Structure

Create or maintain this minimum structure:

```text
.
├── docker-compose.yaml
├── Dockerfile
├── .env.example
├── README.md
├── src/
│   └── ...
└── docs/
    └── vdecent-handover.md
```

You may adapt the structure for the selected framework, but the root-level `docker-compose.yaml`, `Dockerfile`, `.env.example`, and `README.md` are mandatory.

---

## Required README Sections

Create a `README.md` with these sections:

```markdown
# <APP_NAME>

## Overview
Describe what the application does.

## Technology Stack
List the language, framework, runtime, database, and external services.

## V-Decent Compatibility
Explain that the app is designed for V-Decent deployment.

Include:
- Docker Compose file: `docker-compose.yaml`
- No host port mappings
- Public-facing service name
- Internal exposed port
- Health endpoint
- Environment variable configuration
- Stateful/stateless classification

## Local Development

### 1. Copy Environment File
```bash
cp .env.example .env
```

### 2. Build and Start
```bash
docker compose up --build
```

### 3. Test Health
```bash
curl http://localhost:<LOCAL_TEST_PORT>/health
```

If local testing needs host port mapping, create a separate local-only compose override file, such as `docker-compose.local.yaml`. Do not depend on host port mapping in the main `docker-compose.yaml`.

## Production Environment Variables
List every variable required by V-Decent Application Manager.

## Deployment Source
Repository URL:
Branch:
Repository visibility:

## V-Decent Application Manager Registration Notes
Public-facing service:
Production URL:
Internal services that must not be exposed:

## Troubleshooting
Explain common startup, health check, database, and environment-variable issues.
```

---

## Required Handover Document

Create:

```text
docs/vdecent-handover.md
```

It must include:

```markdown
# V-Decent Deployment Handover

## Application Identity
Application name:
Primary shortname:
Production URL:
Developer group:
GitHub account or organization:

## Deployment Source
Repository URL:
Repository visibility:
Branch:
Manifest file: docker-compose.yaml

## Service Exposure
| Service | Expose Publicly? | URL | Notes |
|---|---:|---|---|
| app | Yes | https://<APP_SHORTNAME>.v-decent.org | Main web/API service |
| db | No |  | Internal database only |

## Environment Variables for Production
```env
PORT=80
...
```

## Health Check
Health endpoint:
Expected response:
Startup time estimate:

## Data Persistence
Application type:
External storage:
Docker volumes:
Backup sidecar:
Restore procedure:

## Local Verification Evidence
Commands run:
Results:
Known limitations:

## Deployment Notes for V-Decent Operator
Any special notes needed before approval/deployment.
```

---

## V-Decent Application Manager Flow to Support

Design the repository so the developer can follow this deployment flow:

1. Build and code the application.
2. Verify locally using Docker Compose.
3. Obtain customer/application owner approval.
4. Register the application in V-Decent Application Manager.
5. Provide identity and ownership information.
6. Provide application details:
   - Application name
   - Primary shortname
   - Primary FQDN under `*.v-decent.org`
   - Category/resource size
7. Provide deployment source:
   - Git repository URL
   - Repository visibility
   - Branch
8. For private repositories:
   - Use the public key shown by V-Decent Application Manager.
   - Configure the Git provider/repository to allow access with that key.
   - Run or support **Analyze Manifest** so Application Manager can read `docker-compose.yaml`.
9. Select which service/container is exposed publicly.
10. Leave URL fields empty for internal-only services.
11. Provide production environment variables.
12. Register the application.
13. Trigger deployment.
14. Confirm final status becomes `HEALTHY`.
15. If deployment becomes `UNHEALTHY`, check system logs and fix the app, compose file, health check, or environment variables.

---

## Public Repository Requirements

If the repository is public:

```text
Use HTTPS repository URL.
No deploy key setup should be required.
Provide repository URL, branch, and production environment variables.
```

Avoid this mistake:

```text
Wrong or inaccessible repository URL format.
```

---

## Private Repository Requirements

If the repository is private:

```text
The V-Decent Application Manager must be authorized to access it.
The developer must associate the Application Manager login with the Git provider account when required.
The developer must copy the correct public key shown by Application Manager.
The developer must configure that public key in the Git provider or repository.
The developer must verify that Application Manager can analyze the manifest.
```

Avoid these mistakes:

```text
Private repository public key not configured.
Wrong public key copied.
Deploy key configured on the wrong repository or account.
Application Manager cannot access docker-compose.yaml.
```

---

## URL and Domain Constraints

As of the V-Decent V2.0 guide, custom application domains are not supported by V-Decent Application Manager.

Use only:

```text
https://<shortname>.v-decent.org
```

Do not assume that a custom domain can be used unless V-Decent Operator confirms support.

---

## Local Testing Requirements

Before handing the application to V-Decent operations, run and document:

```bash
docker compose config
docker compose build
docker compose up
docker compose ps
docker compose logs
```

Test the health endpoint:

```bash
curl -i http://localhost:<LOCAL_TEST_PORT>/health
```

Test the main application route:

```bash
curl -i http://localhost:<LOCAL_TEST_PORT>/
```

For apps with a database:

```bash
docker compose exec db pg_isready -U <USER> -d <DATABASE>
```

If a separate local override file is needed, create:

```text
docker-compose.local.yaml
```

Example local command:

```bash
docker compose -f docker-compose.yaml -f docker-compose.local.yaml up --build
```

The main `docker-compose.yaml` must remain V-Decent compatible and must not depend on host port mappings.

---

## AI Agent Development Instructions

When generating code, follow these rules:

1. Prefer simple, reliable architecture over unnecessary complexity.
2. Keep the application container stateless unless the selected pattern explicitly requires state.
3. Use environment variables for all deployment-specific values.
4. Do not hardcode production secrets.
5. Do not use host port mappings in the primary `docker-compose.yaml`.
6. Add a `/health` endpoint.
7. Add Docker health checks.
8. Add `.env.example`.
9. Add clear README instructions.
10. Add `docs/vdecent-handover.md`.
11. Use discrete Docker volumes for any persistent data.
12. Do not expose databases, workers, backup containers, or internal services publicly.
13. Make startup ordering explicit with `depends_on` and health checks where needed.
14. Make logs useful for debugging deployment failures.
15. Ensure the app can restart cleanly with `restart: always`.

---

## Acceptance Criteria

The project is complete only when all items below are true:

```text
[ ] Root-level docker-compose.yaml exists.
[ ] docker-compose.yaml uses expose instead of ports for V-Decent-facing services.
[ ] Application has a Dockerfile.
[ ] Application has .env.example.
[ ] Application has README.md with V-Decent deployment notes.
[ ] Application has docs/vdecent-handover.md.
[ ] Application provides /health endpoint.
[ ] Docker health checks are configured.
[ ] Public-facing service is clearly identified.
[ ] Internal services are not exposed publicly.
[ ] Production environment variables are documented.
[ ] Local Docker Compose startup has been tested.
[ ] Stateful data, if any, is stored in discrete Docker volumes or external storage.
[ ] Private repository instructions are included if repo visibility is private.
[ ] Deployment URL uses *.v-decent.org unless V-Decent Operator confirms otherwise.
```

---

## Common Pitfalls to Avoid

Do not make these mistakes:

```text
Using `ports` in the primary docker-compose.yaml.
Naming the file something other than docker-compose.yaml.
Forgetting .env.example.
Forgetting Docker health checks.
Forgetting the /health endpoint.
Exposing the database publicly.
Assuming container filesystem data will persist.
Assuming custom domains are supported.
Using the wrong private repository public key.
Providing the wrong repository URL.
Failing to document production environment variables.
```

---

## Final Output Expected From the AI Agent

Produce:

```text
Complete application source code
Dockerfile
docker-compose.yaml
.env.example
README.md
docs/vdecent-handover.md
Any required database migration or initialization scripts
Local test commands and expected results
Brief explanation of how to register/deploy in V-Decent Application Manager
```

Before finishing, inspect the generated project against the acceptance criteria and fix any missing item.
