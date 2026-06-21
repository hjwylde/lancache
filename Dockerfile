FROM nginxinc/nginx-unprivileged:1.31-trixie-perl

ARG UID=101
ARG GID=101

USER root
RUN test $GID -eq 101 || groupmod -g ${GID} nginx
RUN test $UID -eq 101 || usermod -u ${UID} -g ${GID} nginx
RUN test $UID -eq 101 || find /etc/nginx -user 101 -exec chown $UID:0 {} +
RUN test $UID -eq 101 || find /var/cache/nginx -user 101 -exec chown $UID:0 {} +
USER $UID

# https://github.com/lancachenet/ubuntu-nginx/blob/master/Dockerfile

RUN mkdir -p /etc/nginx/stream.d
COPY --from=lancachenet/ubuntu-nginx:latest --chown=$UID:0 /etc/nginx/stream.d/ /etc/nginx/stream.d/

# https://github.com/lancachenet/monolithic/blob/master/Dockerfile

LABEL version=3
LABEL description="Single caching container for caching game content at LAN parties."
LABEL maintainer="LanCache.Net Team <team@lancache.net>"

USER root
RUN	apt-get update							;\
	apt-get install -y jq git				;\
    rm -rf /var/lib/apt/lists/*             ;
USER $UID

ENV GENERICCACHE_VERSION=2 \
    CACHE_MODE=monolithic \
    CACHE_INDEX_SIZE=500m \
    CACHE_DISK_SIZE=1000g \
    MIN_FREE_DISK=10g \
    CACHE_MAX_AGE=3560d \
    CACHE_SLICE_SIZE=1m \
    UPSTREAM_DNS="8.8.8.8 8.8.4.4" \
    BEAT_TIME=1h \
    LOGFILE_RETENTION=3560 \
    CACHE_DOMAINS_REPO="https://github.com/uklans/cache-domains.git" \
    CACHE_DOMAINS_BRANCH=master \
    NGINX_WORKER_PROCESSES=auto \
    NGINX_LOG_FORMAT=cachelog

RUN rm /etc/nginx/conf.d/default.conf
COPY --chown=$UID:0 overlay/ /

USER root
RUN mkdir -m 755 -p /data; \
    chown -R $UID:0 /data
RUN chmod +x /scripts/* /hooks/entrypoint-pre.d/* /hooks/supervisord-pre.d/*; \
    ln -s /hooks/entrypoint-pre.d/* /docker-entrypoint.d/; \
    ln -s /hooks/supervisord-pre.d/* /docker-entrypoint.d/
USER $UID

RUN mkdir -m 755 -p /data/cache		;\
	mkdir -m 755 -p /data/info		;\
    mkdir -m 755 -p /data/logs		;\
    mkdir -p /etc/nginx/sites-enabled	;\
    mkdir -p /etc/nginx/stream-enabled ;\
    ln -s /etc/nginx/sites-available/10_cache.conf /etc/nginx/sites-enabled/10_generic.conf; \
    ln -s /etc/nginx/sites-available/20_upstream.conf /etc/nginx/sites-enabled/20_upstream.conf; \
    ln -s /etc/nginx/sites-available/30_metrics.conf /etc/nginx/sites-enabled/30_metrics.conf; \
    ln -s /etc/nginx/stream-available/10_sni.conf /etc/nginx/stream-enabled/10_sni.conf

RUN git clone --depth=1 --no-single-branch https://github.com/uklans/cache-domains/ /data/cachedomains

VOLUME ["/data/logs", "/data/cache", "/data/cachedomains", "/usr/share/nginx"]

EXPOSE 8080 8081 8443
