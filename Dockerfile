FROM mayanedms/mayanedms:latest

# (Optional) You can add ENV overrides or package installs here

# Set working directory
WORKDIR /opt/mayan-edms

# Expose the default web port
EXPOSE 8000

# Default command to start the web app
CMD ["gunicorn", "mayan.wsgi", "--bind", "0.0.0.0:8000"]
