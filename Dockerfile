FROM python:3-alpine
LABEL maintainer="Winston Astrachan"
LABEL description="FlexGet on Alpine Linux"

ARG FLEXGET_VERSION="2.20.27"

RUN addgroup -g 101 -S flexget && \
    adduser -u 100 -S -G flexget flexget

RUN mkdir /config && \
    mkdir /download

VOLUME /config
VOLUME /download

COPY overlay/ /
ADD https://github.com/Flexget/Flexget/tarball/${FLEXGET_VERSION} flexget.tar.gz
RUN \
    # Extract and install FlexGet
    mkdir flexget && \
    tar --strip-components=1 -xzvf flexget.tar.gz -C flexget && \
    cd flexget && \
    python3 setup.py install && \
    \
    # Install python dependencies
    pip install deluge-client && \
    pip install transmissionrpc && \
    \
    # Clean up build files, deps
    rm -rf /flexget /flexget.tar.gz

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["su", "-p", "-s", "/bin/sh", "flexget", "-c", "/usr/local/bin/flexget -c /config/config.yml --loglevel verbose daemon start --autoreload-config"]
