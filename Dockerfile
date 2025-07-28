# Dockerfile to build Mayan EDMS from source

FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libmagic-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    git \
    curl \
    poppler-utils \
    libreoffice \
    unrtf \
    ghostscript \
    tesseract-ocr \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy and install Mayan EDMS
COPY . /app

RUN pip install --upgrade pip && \
    pip install -r requirements/base.txt && \
    pip install -r requirements/production.txt && \
    python setup.py install

# Environment variables
ENV MAYAN_MEDIA_ROOT=/var/lib/mayan \
    MAYAN_SETTINGS_MODULE=mayan.settings.production

# Create directories
RUN mkdir -p /var/lib/mayan && chown -R 1000:1000 /var/lib/mayan

# Port
EXPOSE 8000

# Entrypoint
CMD ["mayan-edms.py", "runserver", "0.0.0.0:8000"]
