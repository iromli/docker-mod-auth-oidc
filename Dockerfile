FROM ubuntu:trusty

RUN apt-get update && apt-get install -y \
    libjansson4 \
    libhiredis0.10 \
    wget \
    libcurl3 \
    apache2 \
    apache2-api-20120211 \
    python \
    && rm -rf /var/lib/apt/lists/*

ENV LIBCJOSE_PKG libcjose_0.4.1-1ubuntu1.trusty.1_amd64.deb

RUN wget -q https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.3/$LIBCJOSE_PKG \
    && dpkg -i $LIBCJOSE_PKG \
    && rm -f $LIBCJOSE_PKG

ENV MOD_OIDC_PKG libapache2-mod-auth-openidc_2.1.3-1ubuntu1.trusty.1_amd64.deb

RUN wget -q https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.1.3/$MOD_OIDC_PKG \
    && dpkg -i $MOD_OIDC_PKG \
    && rm -f $MOD_OIDC_PKG

ENV TINI_VERSION v0.18.0
RUN wget -q https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static -O /usr/bin/tini \
    && chmod +x /usr/bin/tini

RUN a2enmod \
    ssl \
    socache_shmcb \
    cgid \
    auth_openidc

ENV SERVER_NAME localhost
ENV OIDC_PROVIDER https://localhost
ENV OIDC_CACHE_TYPE shm
ENV OIDC_CACHE_SHM_MAXSIZE 32678
ENV OIDC_CACHE_REDIS_URL localhost:6379

RUN mkdir -p /etc/apache2/ssl /app/templates /app/scripts

COPY static/printHeaders.cgi /usr/lib/cgi-bin/
RUN chown www-data:www-data /usr/lib/cgi-bin/printHeaders.cgi \
    && chmod ug+x /usr/lib/cgi-bin/printHeaders.cgi

COPY templates/default-ssl.conf /app/templates
RUN a2ensite default-ssl.conf && a2dissite 000-default.conf

RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

COPY scripts /app/scripts

ENTRYPOINT ["tini", "-g", "--"]
CMD ["sh", "/app/scripts/entrypoint.sh"]
