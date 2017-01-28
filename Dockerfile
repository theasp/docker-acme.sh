FROM alpine:latest

RUN apk add --no-cache busybox curl tar git openssl netcat-openbsd docker

# Internal
ENV ACME_DIR /acme.sh
ENV LE_WORKING_DIR $ACME_DIR
ENV TEMP_DIR /tmp/acme.sh

# External
ENV CERT_DIR /certs
ENV ACCOUNT_DIR /account

RUN git clone --depth 1 https://github.com/Neilpang/acme.sh.git ${TEMP_DIR} \
    &&  mkdir -p ${CERT_DIR} ${ACCOUNT_DIR} \
    && cd /tmp/acme.sh \
    && ./acme.sh --install \
       --home ${ACME_DIR} \
       --certhome ${CERT_DIR} \
       --accountkey ${ACCOUNT_DIR}/account.key \
       --useragent "acme.sh in docker" \
    && ln -s ${ACME_DIR}/acme.sh /usr/local/bin \
    && rm -rf ${TEMP_DIR}

VOLUME $CERT_DIR
VOLUME $ACCOUNT_DIR

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["crond", "-f"]
