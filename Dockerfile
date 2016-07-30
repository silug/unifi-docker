FROM debian
MAINTAINER Steven Pritchard <steven.pritchard@gmail.com>

COPY ["unifi.list", "/etc/apt/sources.list.d/unifi.list"]
COPY ["unifi-entrypoint", "/usr/local/sbin/unifi-entrypoint"]
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
    apt update && \
    apt upgrade -y && \
    apt install -y unifi && \
    apt-get clean

VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi"]

ENTRYPOINT ["/usr/local/sbin/unifi-entrypoint"]

# https://help.ubnt.com/hc/en-us/articles/204910084-UniFi-Change-Default-Ports-for-Controller-and-UAPs
EXPOSE 8080 8443 8880 8843 3478/udp
