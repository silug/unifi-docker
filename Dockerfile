FROM debian:9
LABEL org.opencontainers.image.authors="Steven Pritchard <steven.pritchard@gmail.com>"

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]
COPY ["unifi-entrypoint", "/usr/local/sbin/unifi-entrypoint"]
# hadolint ignore=DL3008
RUN set -e ; \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y \
        gnupg \
        apt-utils \
        apt-transport-https \
        ca-certificates \
        curl \
        procps \
        --no-install-recommends ; \
    echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' > /etc/apt/sources.list.d/unifi.list ; \
    curl -s https://dl.ui.com/unifi/unifi-repo.gpg | apt-key add - ; \
    apt-get update ; \
    apt-get install -y unifi --no-install-recommends ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

ENTRYPOINT ["/usr/local/sbin/unifi-entrypoint"]

# https://help.ubnt.com/hc/en-us/articles/204910084-UniFi-Change-Default-Ports-for-Controller-and-UAPs
EXPOSE 8080 8443 8880 8843 3478/udp
