ARG BASE_IMAGE=library/alpine:latest

FROM docker.io/${BASE_IMAGE}

RUN \
  apk add --update --no-cache rsyslog logrotate supervisor \
  && rm -rf /var/cache/apk/* && \
  mkdir -p /var/log/supervisord /var/run/supervisord

COPY config/logrotate.conf /etc/logrotate.d/rsyslog-server
COPY config/rsyslog.conf /etc/rsyslog.conf
COPY config/supervisord.conf /etc/supervisord.conf

EXPOSE 514/tcp 514/udp

VOLUME /etc/rsyslog.d /var/log

HEALTHCHECK --interval=1m --timeout=3s \
  CMD timeout 2 nc -z 127.0.0.1 514

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisord.conf"]
