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

1. **Setup Environment:**
   Copy the example environment file and customize it:
   ```bash
   cp .env.example .env
   ```

2. **Install Dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the Application:**
   ```bash
   python main.py
   ```
   The app will use the settings defined in your `.env` file.

### Running with Docker

1. **Build and Run:**
   ```bash
   docker-compose up --build
   ```
   *Note: The container now defaults to port 80 for seamless Coolify integration.*

## Deployment

### Coolify

This application is optimized for **Zero-Config** deployment on **Coolify**:

1. Create a new **Application** in Coolify.
2. Select **Docker Compose** as the build pack.
3. In the **Domains** field, simply enter your domain (e.g., `https://your-domain.com`). 
4. Since the app now defaults to port **80**, no additional port configuration is required!

### Deploying Multiple Instances

You can deploy the same repository multiple times with different UIs using **Environment Variables**:

| Variable | Description | Default |
| :--- | :--- | :--- |
| `SITE_NAME` | The title and label shown on the page | `Timezone Web App` |
| `PRIMARY_COLOR` | The hex color for the clock and accents | `#1a73e8` |

**Example for a Green Theme:**
1. In Coolify, go to the application's **Environment Variables**.
2. Add `SITE_NAME=Green Clock` and `PRIMARY_COLOR=#4caf50`.
3. Deploy!

## License

MIT
