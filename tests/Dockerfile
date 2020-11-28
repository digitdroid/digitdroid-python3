ARG PYTHON_VERSION

FROM digitdroid/python3:$PYTHON_VERSION

COPY requirements.txt /requirements.txt
RUN gosu app pip install --no-cache-dir -r /requirements.txt

COPY test-file.sh /docker-entrypoint.d/test-file.sh
COPY test-file.py /docker-entrypoint.d/test-file.py

COPY run_tests.sh /run_tests.sh

CMD ["gosu", "app", "/run_tests.sh"]
