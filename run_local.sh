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

# Launch the app
echo "Launching app on http://localhost:8081"
python main.py
