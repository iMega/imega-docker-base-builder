IMAGE=imega/base-builder
TAG=latest
ALPINE_VERSION=3.15
ARCH=$(shell uname -m)

ifeq ($(ARCH),aarch64)
	ARCH=arm64
endif

ifeq ($(ARCH),x86_64)
	ARCH=amd64
endif

build:
	@docker build --build-arg VERSION=$(TAG) \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		-t $(IMAGE):$(TAG)-$(ARCH) .

login:
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)

release: login build
	@docker tag $(IMAGE):$(TAG)-$(ARCH) $(IMAGE):latest-$(ARCH)
	@docker push $(IMAGE):$(TAG)-$(ARCH)
	@docker push $(IMAGE):latest-$(ARCH)

release-manifest: login
	@docker manifest create $(IMAGE):$(TAG) \
		$(IMAGE):$(TAG)-amd64 \
		$(IMAGE):$(TAG)-ppc64le \
		$(IMAGE):$(TAG)-arm64
	@docker manifest create $(IMAGE):latest \
		$(IMAGE):latest-amd64 \
		$(IMAGE):latest-ppc64le \
		$(IMAGE):latest-arm64
	@docker manifest push $(IMAGE):$(TAG)
	@docker manifest push $(IMAGE):latest

test: build
	@docker run --rm $(IMAGE):$(TAG)-$(ARCH) \
		--packages="wrong-pkg-name" || exit 0
	@docker run --rm $(IMAGE):$(TAG)-$(ARCH) \
		--dev-packages="wrong-pkg-name" || exit 0
	@$(MAKE) test -C tests IMAGE=$(IMAGE) TAG=$(TAG)
