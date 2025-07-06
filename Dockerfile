# Optimized Dockerfile for Sianglao ML Service
# Models are included via Git LFS, no need to download
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

# Copy application code and models (models are in Git LFS)
COPY --chown=sianglao:sianglao . .

# Verify models are present
RUN ls -la saved_models/ && \
    ls -la saved_models/*/model.safetensors || echo "Models will be loaded from Git LFS"

# Make sure the sianglao user owns the app directory
RUN chown -R sianglao:sianglao /app

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

# Health check (longer startup time due to large models)
HEALTHCHECK --interval=30s --timeout=15s --start-period=300s --retries=5 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run the application
CMD ["python", "app.py"]