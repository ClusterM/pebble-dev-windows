FROM debian:bookworm-slim

WORKDIR /app

ENV PATH="$PATH:/root/.local/bin"
ENV DISPLAY=:0
ENV BROWSER="browser-wrapper.sh"
ENV STOP_AFTER=30

RUN apt-get update && \
    apt-get -y install \
        tini \
        curl \
        gdb-multiarch \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        libsdl1.2debian \
        libfdt1 \
        libpixman-1-0 \
        libglib2.0-0 \
        chromium \
        libsdl2-dev && \
        rm -rf /var/lib/apt/lists/* && \
        ln -s /usr/bin/gdb-multiarch /usr/bin/arm-none-eabi-gdb && \
        (curl -LsSf https://astral.sh/uv/install.sh | sh) && \
        uv tool install pebble-tool && \
        pebble sdk install latest

# Copy emu-app-config helpers
COPY content/decode_url.py /usr/bin/decode_url
COPY content/browser-wrapper.sh /usr/bin/browser-wrapper.sh
COPY content/docker-entrypoint.sh /root/docker-entrypoint.sh
RUN chmod +x /usr/bin/browser-wrapper.sh && chmod +x /usr/bin/decode_url

# Patch to track last usage time
RUN sed -i "3i from pathlib import Path\nPath('/tmp/pebble_flag').touch()" `which pebble`

ENTRYPOINT ["tini", "--", "/root/docker-entrypoint.sh"]
CMD []
