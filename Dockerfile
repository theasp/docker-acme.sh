FROM alpine:latest

RUN apk add --no-cache busybox curl tar git openssl netcat-openbsd docker

# Internal
ENV ACME_DIR /acme.sh
ENV LE_WORKING_DIR $ACME_DIR

# External
ENV CERT_DIR /certs
ENV ACCOUNT_DIR /account

ADD https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh /tmp/acme.sh
RUN mkdir -p ${CERT_DIR} ${ACCOUNT_DIR} \
    && INSTALLONLINE=1 sh /tmp/acme.sh \
       --install \
       --home ${ACME_DIR} \
       --certhome ${CERT_DIR} \
       --accountkey ${ACCOUNT_DIR}/account.key \
       --useragent "acme.sh in docker" \
       --auto-upgrade 1 \
    && ln -s ${ACME_DIR}/acme.sh /usr/local/bin \
    && rm -rf /tmp/acme.sh

VOLUME $CERT_DIR
VOLUME $ACCOUNT_DIR

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
