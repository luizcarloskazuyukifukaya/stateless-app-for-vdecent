#!/bin/bash
set -e

echo "Starting local Docker deployment..."

# Find an available port starting from 8081
BASE_PORT=8081
MAX_ATTEMPTS=10
PORT=$BASE_PORT
ATTEMPT=0

echo "Looking for an available port starting at $BASE_PORT..."

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if (echo > /dev/tcp/127.0.0.1/$PORT) >/dev/null 2>&1; then
        echo "Port $PORT is in use, trying next..."
        PORT=$((PORT + 1))
        ATTEMPT=$((ATTEMPT + 1))
    else
        break
    fi
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "Error: Could not find an available port after $MAX_ATTEMPTS attempts."
    exit 1
fi

LOCAL_IP=$(hostname -I | awk '{print $1}')

echo "Launching Docker Compose on port $PORT..."
PORT=$PORT docker compose -f docker-compose.yaml -f docker-compose.dev.yaml up --build -d

echo "App is starting..."
echo "Access the web page for test at:"
echo "1) http://localhost:$PORT"
if [ ! -z "$LOCAL_IP" ]; then
    echo "2) http://$LOCAL_IP:$PORT"
fi

echo "To stop: docker compose down"
