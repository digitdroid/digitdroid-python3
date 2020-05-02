image_version := 3.6.10
py3_image := $(image_version)-slim-stretch
gosu_ver := 1.12
gosu_key := B42F6819007F00F88E364FD4036A9C25BF357DD4
tini_ver := v0.19.0
tini_key := 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
tini_subreaper := true
key_servers := 'ha.pool.sks-keyservers.net \
               hkp://p80.pool.sks-keyservers.net:80 \
               keyserver.ubuntu.com \
               hkp://keyserver.ubuntu.com:80 \
               pgp.mit.edu'

.PHONY: build
build:
	docker build \
	--build-arg IMAGE_VERSION=$(image_version) \
	--build-arg PY3_IMAGE=$(py3_image) \
	--build-arg GOSU_VER=$(gosu_ver) \
	--build-arg GOSU_KEY=$(gosu_key) \
	--build-arg TINI_VER=$(tini_ver) \
	--build-arg TINI_KEY=$(tini_key) \
	--build-arg TINI_SUBREAPER=$(tini_subreaper) \
	--build-arg KEY_SERVERS=$(key_servers) \
	--tag digitdroid/python3:$(image_version) ./debian

.PHONY: test
test:
	docker-compose -f docker-compose.test.yml up --build
