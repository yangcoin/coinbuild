.PHONY: build prepare run test stress seed down setup-apps

COMPOSE = docker-compose
DOCKER = docker
default: windows

windows:
	$(DOCKER) build build -f build/Dockerfile -t ygc_win:1.0

macos:
	$(DOCKER) build build -f build/Dockerfile.macos -t ygc_mac:1.0

linux:
	$(DOCKER) build build -f build/Dockerfile.linux -t ygc_linux:1.0
