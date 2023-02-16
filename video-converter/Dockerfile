FROM jrottenberg/ffmpeg:4.1-alpine

RUN apk add unzip

COPY script.sh /

ENTRYPOINT ["/script.sh"]
