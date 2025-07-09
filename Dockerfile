# Optimized Dockerfile for Sianglao ML Service
# Models are downloaded from HuggingFace during build for robust deployment
FROM python:3.12-slim as production

# Install system dependencies for ML inference
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    ffmpeg \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash sianglao

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code (without models directory)
COPY --chown=sianglao:sianglao . .

# Create models directory structure
RUN mkdir -p saved_models/xls-r saved_models/xlsr-53 saved_models/hubert

# Download models from HuggingFace during build
RUN echo "🔄 Starting model download..." && \
    python -u download_models.py && \
    echo "✅ Model download completed!"

# Verify models are properly downloaded and check file sizes
RUN ls -la saved_models/ && \
    ls -lh saved_models/*/model.safetensors && \
    echo "Model files downloaded successfully from HuggingFace"

# Make startup scripts executable and set ownership
RUN chmod +x railway-start.sh start-dev.sh start-prod.sh start-docker.sh && \
    chown -R sianglao:sianglao /app

# Switch to non-root user
USER sianglao

# Add local bin to PATH
ENV PATH=/home/sianglao/.local/bin:$PATH

# Set production environment variables
ENV FLASK_ENV=production
ENV FLASK_DEBUG=0
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Expose the port
EXPOSE 8000

# Health check (faster startup since models are pre-downloaded)
HEALTHCHECK --interval=30s --timeout=15s --start-period=120s --retries=5 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run the application (using production gunicorn server)
CMD ["./start-docker.sh"]