FROM digitdroid/python3:3.6.10

COPY ./docker-entrypoint.d/00_init-django-app.sh /docker-entrypoint.d/00_init-django-app.sh
RUN chmod +x  /docker-entrypoint.d/00_init-django-app.sh

COPY ./docker-entrypoint.d/10_create-django-superuser.py /docker-entrypoint.d/10_create-django-superuser.py
RUN chmod +x  /docker-entrypoint.d/10_create-django-superuser.py

COPY requirements.txt /requirements.txt
RUN gosu app pip install --no-cache-dir -r /requirements.txt

COPY ./src /app

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
