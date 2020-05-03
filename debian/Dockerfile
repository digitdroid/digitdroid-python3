ARG IMAGE_VERSION=3.8.2
ARG PY3_IMAGE=$IMAGE_VERSION-slim-buster

FROM python:$PY3_IMAGE

ARG GOSU_VER=1.12
ARG GOSU_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4
ARG TINI_VER=v0.19.0
ARG TINI_KEY=595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
ARG TINI_SUBREAPER=true
ARG KEY_SERVERS='ha.pool.sks-keyservers.net keyserver.ubuntu.com'

ENV GOSU_VERSION=$GOSU_VER \
    TINI_VERSION=$TINI_VER \
    TINI_SUBREAPER=$TINI_SUBREAPER

RUN set -ex \
    # install build tools
    && fetchDeps='ca-certificates gpg dirmngr wget git gcc make gettext libcurl4-openssl-dev libc6-dev  \
                 zlib1g-dev libpq-dev libexpat1-dev libxml2-dev libxslt1-dev libjansson-dev libpcre3-dev  \
                 libpng-dev libfreetype6-dev libjpeg-dev libffi-dev libmagic-dev' \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends $fetchDeps \
    # install gosu
    && wget -q -O /usr/local/bin/gosu \
       "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -q -O /usr/local/bin/gosu.asc \
       "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && for server in $(/bin/echo -e $KEY_SERVERS | perl -MList::Util=shuffle -e 'print shuffle(<>);') ; do \
            gpg --no-tty --keyserver "$server" --recv-keys $GOSU_KEY && break || : ; \
       done \
    && gpg --no-tty --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody:root bash -c 'whoami && id' \
    # install tini
    && wget -q -O /usr/local/bin/tini \
        "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-$(dpkg --print-architecture)" \
    && wget -q -O /usr/local/bin/tini.asc \
        "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && for server in $(/bin/echo -e $KEY_SERVERS | perl -MList::Util=shuffle -e 'print shuffle(<>);') ; do \
            gpg --no-tty --keyserver "$server" --recv-keys $TINI_KEY && break || : ; \
       done \
    && gpg --no-tty --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
    && rm -rf "$GNUPGHOME" /usr/local/bin/tini.asc \
    && chmod +x /usr/local/bin/tini \
    && tini -vvv -- bash -c 'true' \
    # cleanup
    && rm -rf /var/cache/apt/* \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /var/lib/apt/lists/* \
    # add user and venv
    && useradd --uid 1000 --no-create-home --user-group app \
    && mkdir -p /app \
    && mkdir -p /venv \
    && chown app.app -R /app \
    && chown app.app -R /venv \
    && gosu app python -m venv /venv \
    && gosu app /venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

ENV LANG="C.UTF-8" \
    LC_COLLATE=C \
    DEBIAN_FRONTEND=noninteractive \
    TERM="xterm-256color" \
    PATH="/venv/bin:${PATH}" \
    XDG_CACHE_HOME="/venv/cache" \
    PYTHONENV="/venv" \
    PYTHONBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_TIMEOUT=60 \
    PIP_DISABLE_PIP_VERSION_CHECK=true

COPY docker-entrypoint.sh /

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

WORKDIR /app

CMD ["python"]
