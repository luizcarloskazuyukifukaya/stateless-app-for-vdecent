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
