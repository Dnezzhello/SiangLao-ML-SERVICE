#!/usr/bin/env python3
"""
Gunicorn configuration for SiangLao ML Service
Production-ready WSGI server configuration
"""

import multiprocessing
import os

# Server socket - Cloud Run requires using PORT environment variable
port = os.environ.get("PORT", "8000")
bind = f"0.0.0.0:{port}"
backlog = 2048

# Worker processes
workers = 1  # Single worker for ML models to avoid memory issues
worker_class = "sync"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 100
timeout = 300  # 5 minutes - ML inference can be slow
keepalive = 2

# Logging
accesslog = "-"
errorlog = "-"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s" %(D)s'

# Security
limit_request_line = 4094
limit_request_fields = 100
limit_request_field_size = 8190

# Process naming
proc_name = "sianglao-ml-service"

# Worker management
preload_app = False  # Load app after forking workers to avoid MPS memory issues
reload = False  # Disable auto-reload in production

# Server mechanics
daemon = False
pidfile = None
user = None
group = None
tmp_upload_dir = None
secure_scheme_headers = {
    'X-FORWARDED-PROTOCOL': 'ssl',
    'X-FORWARDED-PROTO': 'https',
    'X-FORWARDED-SSL': 'on'
}

# SSL (if needed)
keyfile = None
certfile = None

# Memory optimization for ML models
def when_ready(server):
    """Called when server is ready to accept requests"""
    server.log.info("🚀 SiangLao ML Service is ready!")

def worker_exit(server, worker):
    """Called when worker exits"""
    server.log.info(f"Worker {worker.pid} exited")

def pre_fork(server, worker):
    """Called before worker fork"""
    server.log.info(f"Worker {worker.pid} forked")

def post_fork(server, worker):
    """Called after worker fork"""
    server.log.info(f"Worker {worker.pid} started")
    
    # Handle MPS device initialization after fork
    import torch
    import os
    if torch.backends.mps.is_available() and os.getenv("DEVICE", "auto") in ["auto", "mps"]:
        try:
            # Test MPS availability after fork
            _ = torch.zeros(1, device="mps")
            server.log.info(f"Worker {worker.pid}: MPS initialized successfully")
        except Exception as e:
            server.log.warning(f"Worker {worker.pid}: MPS failed after fork ({e}), will fallback to CPU")
            # Force CPU mode for this worker
            os.environ["DEVICE"] = "cpu"

def on_exit(server):
    """Called when server shuts down"""
    server.log.info("🛑 SiangLao ML Service shutting down")