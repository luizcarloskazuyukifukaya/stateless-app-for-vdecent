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

# Launch the app
echo "App is starting..."
echo "Access the web page for test at:"
echo "1) http://localhost:8081"
if [ ! -z "$LOCAL_IP" ]; then
    echo "2) http://$LOCAL_IP:8081"
fi

python main.py
