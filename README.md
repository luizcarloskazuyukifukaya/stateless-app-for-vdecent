# Stateless App for V-Decent

A simple, lightweight stateless web application built with FastAPI. This project serves a static `index.html` page and is designed to be easily containerized and deployed.

## Features

- **FastAPI Backend:** High-performance Python framework for building APIs.
- **Static Content Hosting:** Serves static files from the `static/` directory.
- **Stateless Design:** No persistent state within the application, making it ideal for scalable cloud deployments.
- **Dockerized:** Includes a `Dockerfile` and `docker-compose.yaml` for easy environment setup and deployment.

## Project Structure

```text
.
├── Dockerfile              # Docker image configuration
├── docker-compose.yaml     # Docker Compose for local orchestration
├── main.py                 # FastAPI application entry point
├── requirements.txt        # Python dependencies
├── run_local.sh            # Helper script to run the app locally
└── static/                 # Directory for static assets
    └── index.html          # Main landing page
```

## Getting Started

### Prerequisites

- Python 3.9+
- Docker (optional, for containerized execution)

### Running Locally

1. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the Application:**
   ```bash
   python main.py
   ```
   The app will be available at `http://localhost:8081`.

### Running with Docker

1. **Build and Run:**
   ```bash
   docker-compose up --build
   ```
   The app will be available at `http://localhost:8081`.

## Deployment

### Coolify

This application is fully compatible with **Coolify**. To deploy:

1. With Coolify for the New Resource, select **Applications**.
2. Select the **Git Based** type based on your repository (Public or Private).
3. Select **Docker Compose** as the **Build Pack**.
4. Set the **Docker Compose Location** to `/docker-compose.yaml`.
5. Set the **Destination Port** for the `web` service to `8081`.
6. Deploy!

## License

MIT
