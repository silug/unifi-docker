FROM debian:9
LABEL org.opencontainers.image.authors="Steven Pritchard <steven.pritchard@gmail.com>"

COPY ["unifi-entrypoint", "/usr/local/sbin/unifi-entrypoint"]
RUN apt update && \
    apt upgrade -y && \
    apt install -y gnupg apt-utils apt-transport-https ca-certificates curl procps && \
    curl -s https://dl.ui.com/unifi/unifi-repo.gpg | apt-key add - && \
    echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' > /etc/apt/sources.list.d/unifi.list && \
    apt update && \
    apt upgrade -y && \
    apt install -y unifi pcregrep && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

ENTRYPOINT ["/usr/local/sbin/unifi-entrypoint"]

# https://help.ubnt.com/hc/en-us/articles/204910084-UniFi-Change-Default-Ports-for-Controller-and-UAPs
EXPOSE 8080 8443 8880 8843 3478/udp
