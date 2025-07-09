#!/usr/bin/env python3
"""
WSGI entry point for production deployment
"""

import os
import sys
from pathlib import Path

# Add the application directory to the Python path
sys.path.insert(0, str(Path(__file__).parent))

# Import the Flask application
from app import app, initialize_service

# Initialize the service when the WSGI module is loaded
if not initialize_service():
    print("❌ Failed to initialize service")
    sys.exit(1)

# This is the callable that WSGI servers will use
application = app

if __name__ == "__main__":
    # This allows running with python wsgi.py for testing
    app.run(host="0.0.0.0", port=8000, debug=False)