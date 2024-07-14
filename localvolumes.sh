#!/bin/bash

#ingress doesnt allow IPs for host so we will workaround this with /etc/hosts - maybe not needed?
# echo "192.168.1.154    plex.local" | sudo tee -a /etc/hosts

mkdir -p /mnt/data/{config,movies,tv,torrents}
mkdir -p /mnt/data/config/{plex,sonarr,radarr,torrent,requests}

