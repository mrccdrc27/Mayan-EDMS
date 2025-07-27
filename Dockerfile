FROM mayanedms/mayanedms:latest
EXPOSE 8000
CMD ["/usr/bin/supervisord"]
