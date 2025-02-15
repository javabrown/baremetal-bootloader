#!/bin/bash
set -e  # Stop on error

echo "🔧 Ensuring scripts are executable..."
chmod +x /app/scripts/*.sh

# Keep container running for interactive use
exec "$@"
