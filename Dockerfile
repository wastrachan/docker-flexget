FROM python:3.7-alpine
LABEL maintainer="Winston Astrachan"
LABEL description="FlexGet on Alpine Linux"

ARG FLEXGET_VERSION="3.1.45"

ENV DEPS \
    libjpeg \
    zlib
ENV DEPS_BUILD \
    gcc \
    libgcc \
    jpeg-dev \
    musl-dev \
    zlib-dev

RUN \
    addgroup -g 101 -S flexget && \
    adduser -u 100 -S -G flexget flexget && \
    \
    mkdir /config && \
    mkdir /download && \
    \
    apk add --no-cache $DEPS $DEPS_BUILD && \
    pip install -U setuptools pip packaging

VOLUME /config
VOLUME /download
ADD https://github.com/Flexget/Flexget/tarball/v${FLEXGET_VERSION} flexget.tar.gz

RUN \
    mkdir flexget && \
    tar --strip-components=1 -xzvf flexget.tar.gz -C flexget && \
    cd flexget && \
    python3 setup.py install && \
    \
    pip install deluge-client && \
    pip install transmissionrpc && \
    \
    rm -rf /flexget /flexget.tar.gz && \
    apk del $DEPS_BUILD

COPY overlay/ /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["su", "-p", "-s", "/bin/sh", "flexget", "-c", "/usr/local/bin/flexget -c /config/config.yml --loglevel verbose daemon start --autoreload-config"]
