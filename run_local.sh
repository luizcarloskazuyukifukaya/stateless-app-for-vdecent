#!/bin/bash

# Exit on error
set -e

echo "Starting local deployment..."

# Check if virtual environment exists, if not create it
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
echo "Installing dependencies..."
pip install -r requirements.txt

# Get local IP address
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Launch the app with a specific port for local testing
echo "App is starting..."

# Find an available port starting from 8081
BASE_PORT=8081
MAX_ATTEMPTS=10
PORT=$BASE_PORT
ATTEMPT=0

echo "Looking for an available port starting at $BASE_PORT..."

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    # Try to connect to the port. If it succeeds, the port is in use.
    # Note: Bash handles /dev/tcp internally. We use a subshell to avoid
    # terminating the main script if it fails (which is what we want).
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

echo "App is starting on port $PORT..."
echo "Access the web page for test at:"
echo "1) http://localhost:$PORT"
if [ ! -z "$LOCAL_IP" ]; then
    echo "2) http://$LOCAL_IP:$PORT"
fi

PORT=$PORT python main.py
