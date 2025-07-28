# Use the official base image
FROM mayanedms/mayanedms:latest

# Copy override to fix proxy headers & CSRF handling
COPY settings_override.py /opt/mayan-edms/settings/local.py

# Define environment variables matching your Compose spec
ENV \
  # Database
  MAYAN_DATABASES="{
    'default':{
      'ENGINE':'django.db.backends.postgresql',
      'NAME':'${MAYAN_DATABASE_NAME}',
      'PASSWORD':'${MAYAN_DATABASE_PASSWORD}',
      'USER':'${MAYAN_DATABASE_USER}',
      'HOST':'${MAYAN_DATABASE_HOST}',
      'PORT':${MAYAN_DATABASE_PORT}
    }
  }" \
  # Broker & backend
  MAYAN_CELERY_BROKER_URL="${MAYAN_CELERY_BROKER_URL}" \
  MAYAN_CELERY_RESULT_BACKEND="${MAYAN_CELERY_RESULT_BACKEND}" \
  # Locking
  MAYAN_LOCK_MANAGER_BACKEND="mayan.apps.lock_manager.backends.redis_lock.RedisLock" \
  MAYAN_LOCK_MANAGER_BACKEND_ARGUMENTS="{ 'redis_url': '${MAYAN_CELERY_RESULT_BACKEND}' }" \
  # App behavior
  MAYAN_ALLOWED_HOSTS="${MAYAN_ALLOWED_HOSTS}" \
  MAYAN_COMMON_ENABLE_HTTP_HOST_VALIDATION=True \
  MAYAN_COMMON_DISABLE_LOCAL_STORAGE_CHECK=True \
  MAYAN_COMMON_DEBUG=True \
  MAYAN_COMMON_SITE_URL="${MAYAN_COMMON_SITE_URL}" \
  DJANGO_CSRF_TRUSTED_ORIGINS="${DJANGO_CSRF_TRUSTED_ORIGINS}" \
  SECURE_PROXY_SSL_HEADER="HTTP_X_FORWARDED_PROTO,https" \
  # Media volume
  MAYAN_MEDIA_ROOT="/var/lib/mayan"

EXPOSE 8000

CMD ["run_frontend"]
