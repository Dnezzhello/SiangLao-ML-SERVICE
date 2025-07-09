#!/bin/bash
set -e

echo "🐳 Starting SiangLao ML Service in Docker (PRODUCTION mode)..."

# Check if model files exist
if [ -f "saved_models/xls-r/model.safetensors" ] && [ -f "saved_models/xlsr-53/model.safetensors" ] && [ -f "saved_models/hubert/model.safetensors" ]; then
    echo "✅ All models are ready"
    echo "📊 Model sizes:"
    ls -lh saved_models/*/model.safetensors | awk '{print "  " $9 ": " $5}'
else
    echo "❌ Models not found - this should not happen in Docker build"
    exit 1
fi

# Start the application with gunicorn (production WSGI server)
echo "🚀 Starting production server with gunicorn..."
exec gunicorn --config gunicorn.conf.py wsgi:application