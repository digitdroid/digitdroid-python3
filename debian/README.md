# digitdroid-python3 

This docker image based on [python slim docker image][0]. The image include [gosu][1], [tini][2] and some system libraries required by popular Python and Django packages.

    docker pull digitdroid/python3:latest

## Dockerfile example

    FROM digitdroid/python3:latest
    COPY requirements.txt /requirements.txt
    RUN gosu app pip install --no-cache-dir -r /requirements.txt
    COPY ./src /app
    EXPOSE 8000
    CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

## Source repository

You can find source code for this image [here][3].

[0]: https://hub.docker.com/_/python/
[1]: https://github.com/tianon/gosu
[2]: https://github.com/krallin/tini
[3]: https://github.com/digitdroid/digitdroid-python3
