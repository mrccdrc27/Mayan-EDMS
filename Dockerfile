FROM mayanedms/mayanedms:s4.3

# Switch to root to make modifications
USER root

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create entrypoint script directly in the Dockerfile
RUN cat > /usr/local/bin/railway-entrypoint.sh << 'EOF'
#!/bin/bash
set -e

echo "Starting Mayan EDMS initialization..."

# Convert Railway environment variables to Mayan format
if [ -n "$DATABASE_URL" ]; then
    # Parse DATABASE_URL and set MAYAN_DATABASES
    python3 -c "
import os
from urllib.parse import urlparse

db_url = os.environ.get('DATABASE_URL')
if db_url:
    parsed = urlparse(db_url)
    db_config = {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': parsed.path[1:],  # Remove leading slash
        'USER': parsed.username,
        'PASSWORD': parsed.password,
        'HOST': parsed.hostname,
        'PORT': parsed.port or 5432
    }
    
    # Set environment variable for Mayan
    import json
    os.environ['MAYAN_DATABASES'] = json.dumps({'default': db_config})
    
    # Export for the shell
    with open('/tmp/db_env.sh', 'w') as f:
        f.write(f\"export MAYAN_DATABASES='{json.dumps({\"default\": db_config})}'\")
"
    source /tmp/db_env.sh 2>/dev/null || true
fi

# Set other required environment variables if not set
export MAYAN_CELERY_BROKER_URL=${MAYAN_CELERY_BROKER_URL:-$RABBITMQ_URL}
export MAYAN_ALLOWED_HOSTS=${MAYAN_ALLOWED_HOSTS:-"*"}

# Wait for database to be ready
echo "Waiting for database..."
timeout=60
counter=0
until python3 -c "
import os
import django
from django.conf import settings
from django.core.management import execute_from_command_line
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mayan.settings.production')
django.setup()
from django.db import connection
connection.ensure_connection()
" 2>/dev/null; do
    counter=$((counter + 1))
    if [ $counter -gt $timeout ]; then
        echo "Database connection timeout"
        exit 1
    fi
    echo "Waiting for database... ($counter/$timeout)"
    sleep 1
done

echo "Database is ready!"

# Use the original Mayan entrypoint for setup
echo "Running initial setup..."
/usr/local/bin/entrypoint.sh run_initial_setup_or_perform_upgrade

# Start the frontend server
echo "Starting Mayan EDMS frontend..."
exec /usr/local/bin/entrypoint.sh run_frontend
EOF

RUN chmod +x /usr/local/bin/railway-entrypoint.sh

# Switch back to mayan user
USER mayan

# Set working directory
WORKDIR /var/lib/mayan

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/authentication/login/ || exit 1

# Use our custom entrypoint
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
