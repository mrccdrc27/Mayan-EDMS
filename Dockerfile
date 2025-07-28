FROM mayanedms/mayanedms:latest

ENV MAYAN_DATABASE_ENGINE=django.db.backends.postgresql \
    MAYAN_DATABASE_NAME=railway \
    MAYAN_DATABASE_USER=postgres \
    MAYAN_DATABASE_PASSWORD=hpQmgGMvHJnGYcCqUhWNiuhqYIaOSvED \
    MAYAN_DATABASE_HOST=postgres.railway.internal \
    MAYAN_DATABASE_PORT=5432 \
    MAYAN_CELERY_BROKER_URL=amqp://bR88jsDWb0wRAirK:vrrxQZN~3VODWEV7cC-Il4xZ6wq7I3F4@mainline.proxy.rlwy.net:40157// \
    MAYAN_MEDIA_ROOT=/var/lib/mayan \
    MAYAN_ALLOWED_HOSTS=mayan-edms-production.up.railway.app,localhost,127.0.0.1 \
    MAYAN_COMMON_ENABLE_HTTP_HOST_VALIDATION=True \
    MAYAN_COMMON_DISABLE_LOCAL_STORAGE_CHECK=True \
    MAYAN_COMMON_DEBUG=True \
    DJANGO_CSRF_TRUSTED_ORIGINS=https://mayan-edms-production.up.railway.app

EXPOSE 8000
