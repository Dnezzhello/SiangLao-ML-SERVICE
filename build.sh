#!/bin/bash
set -e

echo "🔧 Railway Build Script for Git LFS Models"

# Ensure Git LFS is installed
echo "📦 Installing Git LFS..."
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install -y git-lfs

# Initialize Git LFS
echo "🔄 Initializing Git LFS..."
git lfs install

# Pull LFS files
echo "📥 Pulling LFS files..."
git lfs pull

# Verify model files
echo "✅ Verifying model files..."
ls -lh saved_models/*/model.safetensors

echo "✅ Build complete!"