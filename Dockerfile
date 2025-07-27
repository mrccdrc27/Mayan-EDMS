FROM mayanedms/mayanedms:latest

ENV MAYAN_DATABASE_ENGINE=django.db.backends.postgresql \
    MAYAN_DATABASE_NAME=railway \
    MAYAN_DATABASE_USER=postgres \
    MAYAN_DATABASE_PASSWORD=hpQmgGMvHJnGYcCqUhWNiuhqYIaOSvED \
    MAYAN_DATABASE_HOST=postgres.railway.internal \
    MAYAN_DATABASE_PORT=5432 \
    MAYAN_CELERY_BROKER_URL=amqp://bR88jsDWb0wRAirK:vrrxQZN~3VODWEV7cC-Il4xZ6wq7I3F4@mainline.proxy.rlwy.net:40157// \
    MAYAN_MEDIA_ROOT=/var/lib/mayan

EXPOSE 8000

CMD ["mayan-edms.py", "runserver_plus", "0.0.0.0:8000"]
