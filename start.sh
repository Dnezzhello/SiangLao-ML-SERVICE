#!/bin/bash
set -e

echo "🚀 Starting SiangLao ML Service..."

# Verify models directory exists
if [ ! -d "./saved_models" ]; then
    echo "❌ Models directory not found!"
    exit 1
fi

# Start the Flask application
python app.py