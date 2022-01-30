# Ubuntu 20.04.* LTS
ARG OS_VERSION=focal-20220105
FROM ubuntu:${OS_VERSION}

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        # Graphical environment and multi-process management
        supervisor \
        x11vnc \
        xbase-clients \
        xvfb \
        \
        # Build time dependencies
        curl \
        ca-certificates \
    # Cleanup to keep image layer small
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/apt/lists.d/* \
    && apt-get autoremove \
    && apt-get clean \
    && apt-get autoclean

############### noVNC remote desktop in a browser

# Setup noVNC
ARG NOVNC_VERSION=1.3.0
RUN curl --location \
        --output novnc.tar.gz \
        https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz \
    && mkdir --parents /novnc \
    && tar xvzf novnc.tar.gz \
        --strip-components=1 \
        --directory /novnc \
    && rm novnc.tar.gz

# Setup websockify
ARG WEBSOCKIFY_VERSION=0.10.0
RUN curl --location \
        --output websockify.tar.gz \
        https://github.com/novnc/websockify/archive/refs/tags/v${WEBSOCKIFY_VERSION}.tar.gz \
    && mkdir --parents /novnc/utils/websockify \
    && tar xvzf websockify.tar.gz \
        --strip-components=1 \
        --directory /novnc/utils/websockify \
    && rm websockify.tar.gz

RUN ln -s /novnc/vnc.html /novnc/index.html

############### Multi-process startup configuration
COPY ./system/services /services
ADD ./system/supervisord.conf /etc/supervisord.conf

############### Graphical environment configuration
ENV DISPLAY :0
ENV RESOLUTION=1280x800
ENV NOVNC_PORT=8080

############### Expose ports
# noVNC
EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]
