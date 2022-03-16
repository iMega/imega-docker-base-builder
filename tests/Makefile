IMAGE=imega/base-builder
TAG=latest
ARCH=$(shell uname -m)

ifeq ($(ARCH),aarch64)
        ARCH=arm64
endif

ifeq ($(ARCH),x86_64)
        ARCH=amd64
endif

build: build-fs
	@docker build -t imega/tidy .

build-fs:
	@docker run --rm=false \
		-v $(CURDIR)/build:/build \
		$(IMAGE):$(TAG)-$(ARCH) \
		--packages="tidyhtml"

test: build
	@echo "<hTmL></hTmL>" | docker run --rm=false -i imega/tidy -xml -iqu | grep "<HTML></HTML>"

.PHONY: build
