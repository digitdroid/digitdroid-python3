#!/bin/sh

PY3_IMAGE=3.6.6-slim-stretch
GOSU_VER=1.10
GOSU_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4
TINI_VER=v0.18.0
TINI_KEY=595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
TINI_SUBREAPER=true

KEY_SERVERS=$(cat << END
ha.pool.sks-keyservers.net
hkp://p80.pool.sks-keyservers.net:80
keyserver.ubuntu.com
hkp://keyserver.ubuntu.com:80
pgp.mit.edu
END
)

docker build \
       --build-arg PY3_IMAGE=${PY3_IMAGE} \
       --build-arg GOSU_VER=${GOSU_VER} \
       --build-arg GOSU_KEY=${GOSU_KEY} \
       --build-arg TINI_VER=${TINI_VER} \
       --build-arg TINI_KEY=${TINI_KEY} \
       --build-arg TINI_SUBREAPER=${TINI_SUBREAPER} \
       --build-arg KEY_SERVERS="${KEY_SERVERS}" \
       --tag digitdroid/python3 ./debian
