FROM jrottenberg/ffmpeg

COPY script.sh /
RUN chmod +x /script.sh \
    && apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/script.sh"]
