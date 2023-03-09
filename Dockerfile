ARG BASE_IMAGE=alpine:latest

FROM docker.io/${BASE_IMAGE}

RUN \
  apk add --update --no-cache rsyslog \
  && rm -rf /var/cache/apk/*

COPY rsyslog.conf /etc/rsyslog.conf

EXPOSE 514/tcp 514/udp

VOLUME /etc/rsyslog.d /var/log

HEALTHCHECK --interval=1m --timeout=3s \
  CMD timeout 2 nc -z 127.0.0.1 514

ENTRYPOINT ["/usr/sbin/rsyslogd"]
CMD ["-n"]
