#!/bin/bash
set -e

# Activate virtual environment only if not in Docker
if [ -d ".venv" ]; then
    echo "🔧 Activating virtual environment for local development..."
    source .venv/bin/activate
else
    echo "🐳 Running in Docker environment (no virtual environment needed)"
fi

echo "🚀 Starting SiangLao ML Service in PRODUCTION mode..."

# Check if model files exist
if [ -f "saved_models/xls-r/model.safetensors" ] && [ -f "saved_models/xlsr-53/model.safetensors" ] && [ -f "saved_models/hubert/model.safetensors" ]; then
    echo "✅ All models are ready"
    echo "📊 Model sizes:"
    ls -lh saved_models/*/model.safetensors | awk '{print "  " $9 ": " $5}'
else
    echo "❌ Models not found - downloading..."
    mkdir -p saved_models/xls-r saved_models/xlsr-53 saved_models/hubert
    python download_models.py
fi

# Start the application with gunicorn (production WSGI server)
echo "🚀 Starting production server with gunicorn..."
gunicorn --config gunicorn.conf.py wsgi:application