#!/bin/bash
set -e

echo "🚀 Starting SiangLao ML Service on Railway..."

# Check if model files are actual files or LFS pointers
if [ -f "saved_models/xls-r/model.safetensors" ]; then
    # Check file size - LFS pointers are tiny (~130 bytes)
    XLS_SIZE=$(stat -c%s "saved_models/xls-r/model.safetensors")
    if [ $XLS_SIZE -lt 1000 ]; then
        echo "❌ Git LFS files not properly loaded (files are LFS pointers)"
        echo "💡 Running model download as fallback..."
        python download_models.py
    else
        echo "✅ Git LFS models loaded successfully"
    fi
else
    echo "❌ Model files not found"
    echo "📁 Ensuring saved_models directory structure exists..."
    mkdir -p saved_models/xls-r
    mkdir -p saved_models/xlsr-53
    mkdir -p saved_models/hubert
    echo "💡 Downloading models..."
    python download_models.py
fi

# Start the application
python app.py