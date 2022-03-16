ARG ALPINE_VERSION
FROM alpine:$ALPINE_VERSION

ARG VERSION
ARG ALPINE_VERSION

LABEL maintainer="Dmitry Stoletoff info@imega<dot>ru" \
    version=$VERSION \
    description="Create rootfs for docker." \
    from_image="alpine:$ALPINE_VERSION" \
    url="https://github.com/imega-docker/base-builder" \
    changelog="https://github.com/imega-docker/base-builder/blob/master/CHANGELOG.md" \
    contributing="https://github.com/imega-docker/base-builder/blob/master/CONTRIBUTING.md" \
    license="https://github.com/imega-docker/base-builder/blob/master/LICENSE.txt"

VOLUME ["/build", "/src", "/runner"]

ADD build.sh /

RUN apk --update add bash

ENTRYPOINT ["/build.sh"]
