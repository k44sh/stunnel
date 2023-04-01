ARG ALPINE_VERSION=edge
ARG USER=stunnel

FROM alpine:${ALPINE_VERSION} as builder
ENV TZ="UTC" \
  PUID="1000" \
  PGID="1000"

ARG USER
RUN apk --update --no-cache add stunnel openssl
RUN rm -rf /etc/stunnel/stunnel.conf /tmp/* /var/cache/apk/*
RUN stunnel -version

COPY rootfs /
RUN chmod +x /init

RUN ln -sf /dev/stdout /var/log/stunnel.log

VOLUME [ "/etc/stunnel" ]

ENTRYPOINT [ "/init" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s CMD /usr/local/bin/healthcheck
