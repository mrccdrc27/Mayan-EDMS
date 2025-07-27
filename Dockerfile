FROM mayanedms/mayanedms:latest
EXPOSE 8000
CMD ["mayan-edms.py", "runserver_plus", "0.0.0.0:8000"]
