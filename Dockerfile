FROM alpine:3.4

ENV VERSION 2.3.0

RUN apk add --no-cache busybox curl tar git openssl netcat-openbsd

# RUN curl -L -o - https://github.com/Neilpang/acme.sh/archive/${VERSION}.tar.gz | tar -C /tmp -x -z -f -

ENV ACME.SH_DIR /acme.sh
ENV CERT_DIR /certs
ENV ACCOUNT_DIR /account

RUN git clone --depth 1 https://github.com/Neilpang/acme.sh.git /tmp/acme.sh && \
    &&  mkdir -p ${CERT_DIR} ${ACCOUNT_DIR} \
    && cd /tmp/acme.sh \
    && ./acme.sh --install \
       --home ${ACME.SH_DIR} \
       --certhome ${CERT_DIR} \
       --accountkey ${ACCOUNT_DIR}/account.key \
       --accountconf ${ACCOUNT_DIR}/account.conf \
       --useragent "
