FROM python:3.11-alpine
LABEL maintainer="Winston Astrachan"
LABEL description="FlexGet on Alpine Linux"
ARG FLEXGET_VERSION="3.5.5"

# Add users before any software to prevent UID/GID conflicts
RUN addgroup -S -g 101 flexget; \
    adduser -S -H -G flexget -u 101 flexget

# Add dependencies
RUN set -eux; \
    apk add --update --no-cache \
        libjpeg \
        zlib \
        libstdc++ \
    ; \
    mkdir \
        /config \
        /download \
        /flexget \
    ; \
    pip install -U setuptools pip packaging

VOLUME /config
VOLUME /download
ADD https://github.com/Flexget/Flexget/tarball/v${FLEXGET_VERSION} flexget.tar.gz

# Install flexget
RUN set -eux; \
    apk add --update --no-cache --virtual .build-deps \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        jpeg-dev \
        musl-dev \
        zlib-dev \
    ; \
    tar --strip-components=1 -xzvf flexget.tar.gz -C /flexget; \
    cd /flexget; \
    pip install .; \
    pip install deluge-client; \
    pip install transmission-rpc; \
    \
    rm -rf /flexget /flexget.tar.gz; \
    apk del .build-deps

COPY overlay/ /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["su", "-p", "-s", "/bin/sh", "flexget", "-c", "/usr/local/bin/flexget -c /config/config.yml --loglevel verbose daemon start --autoreload-config"]
