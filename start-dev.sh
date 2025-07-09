#!/bin/bash
set -e

echo "🚀 Starting SiangLao ML Service in DEVELOPMENT mode..."

# Check if model files exist
if [ -f "saved_models/xls-r/model.safetensors" ] && [ -f "saved_models/xlsr-53/model.safetensors" ] && [ -f "saved_models/hubert/model.safetensors" ]; then
    echo "✅ All models are ready"
else
    echo "❌ Models not found - downloading..."
    mkdir -p saved_models/xls-r saved_models/xlsr-53 saved_models/hubert
    python download_models.py
fi

# Start the application with Flask development server
echo "🚀 Starting development server with Flask..."
python app.py