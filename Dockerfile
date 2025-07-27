# Use the official prebuilt Mayan EDMS image
FROM mayanedms/mayanedms:latest

# Set the working directory
WORKDIR /opt/mayan-edms

# Expose the default Mayan port
EXPOSE 8000

# Optional: you can override default settings using ENV vars from Railway

# Start the built-in process launcher (handles web, workers, etc.)
CMD ["/usr/bin/supervisord"]
