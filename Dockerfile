FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    unzip \
    fonts-dejavu-core \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /tmp/upload/

RUN set -e; \
    if [ -f /tmp/upload/viral-commerce-agent-complete.zip ]; then \
      unzip -q -o /tmp/upload/viral-commerce-agent-complete.zip -d /tmp/unpacked; \
      cp -a /tmp/unpacked/viral-commerce-agent/. /app/; \
    else \
      cp -a /tmp/upload/. /app/; \
    fi; \
    rm -rf /tmp/upload /tmp/unpacked; \
    sed -i 's/"-preset",/"-threads", "2", "-preset",/g' /app/worker/ffmpeg_renderer.py || true; \
    pip install --no-cache-dir -r /app/requirements.txt; \
    mkdir -p /app/data /app/media/scenes /app/media/renders; \
    chmod -R 777 /app

ENV PORT=8000
EXPOSE 8000

CMD ["python3", "server.py"]
