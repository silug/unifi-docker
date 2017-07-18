# unifi-docker
Run Ubiquiti Networks UniFi Controller in Docker.  See https://hub.docker.com/r/silug/unifi/ for more information.

To use, run something like this:

    mkdir -pv /srv/docker/unifi-store/{run,log,lib}
    docker pull silug/unifi
    docker run -p 8080:8080 -p 8443:8443 -p 8880:8880 -p 8843:8843 -p 3478:3478/udp --name=unifi --rm -v /srv/docker/unifi-store/run:/var/run/unifi -v /srv/docker/unifi-store/log:/var/log/unifi -v /srv/docker/unifi-store/lib:/var/lib/unifi silug/unifi

(You might need to preface the port mappings with the local IP address (`-p localip:8080:8080`, for example) to get Docker to bind to the right IP.)

Once set up, to run automatically under `systemd`, use a unit file like this:

    [Unit]
    Description=Unifi controller
    Requires=docker.service
    After=docker.service
    
    [Service]
    User=root
    Restart=on-failure
    RestartSec=10
    ExecStartPre=-/usr/bin/docker kill unifi
    ExecStartPre=-/usr/bin/docker rm unifi
    ExecStartPre=-/bin/rm -f /srv/docker/unifi-store/run/unifi.pid
    ExecStart=/usr/bin/docker run -p 8080:8080 -p 8443:8443 -p 8880:8880 -p 8843:8843 -p 3478:3478/udp --name=unifi --rm -v /srv/docker/unifi-store/run:/var/run/unifi -v /srv/docker/unifi-store/log:/var/log/unifi -v /srv/docker/unifi-store/lib:/var/lib/unifi silug/unifi
    ExecStop=-/usr/bin/docker stop unifi
    
    [Install]
    WantedBy=multi-user.target
