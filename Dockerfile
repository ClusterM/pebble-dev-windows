FROM debian:bookworm-slim

WORKDIR /app

ENV PATH="$PATH:/root/.local/bin"
ENV DISPLAY=:0
ENV BROWSER="browser-wrapper.sh"
ENV STOP_AFTER=30
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies and build tools
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        tini \
        curl \
        gdb-multiarch \
        python3 \
        python3-venv \
        nodejs \
        npm \
        libsdl1.2debian \
        libfdt1 \
        libpixman-1-0 \
        libglib2.0-0 \
        chromium \
        libsdl2-dev && \
    # Install uv and pebble-tool
    (curl -LsSf https://astral.sh/uv/install.sh | sh) && \
    uv tool install pebble-tool && \
    pebble sdk install latest && \
    # Clean up: remove uv (no longer needed) and clear caches
    rm -rf /root/.local/bin/uv /root/.cargo/bin/uv /var/lib/apt/lists/* /root/.cache/uv && \
    # Create gdb symlink
    ln -s /usr/bin/gdb-multiarch /usr/bin/arm-none-eabi-gdb

# Copy emu-app-config helpers
COPY content/decode_url.py /usr/bin/decode_url
COPY content/browser-wrapper.sh /usr/bin/browser-wrapper.sh
COPY content/docker-entrypoint.sh /root/docker-entrypoint.sh
RUN chmod +x /usr/bin/browser-wrapper.sh /usr/bin/decode_url /root/docker-entrypoint.sh

# Patch to track last usage time
RUN sed -i "3i from pathlib import Path\nPath('/tmp/pebble_flag').touch()" `which pebble`

ENTRYPOINT ["tini", "--", "/root/docker-entrypoint.sh"]
CMD []
