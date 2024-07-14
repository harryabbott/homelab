# Homelab

This repo is an attempt at documenting the creation of my homelab setup. 

The media stack is:
- **Plex**  -    (Media Streaming)
- **Radarr**    -    (Finds torrents of movies)
- **Sonarr**    -    (Finds torrents of tv shows)
- **Prowlarr**  -    (allows me to configure the indexes of torrents for sonarr and radarr in one place)
- **Flaresolverr**  -    (Solves cloudflare challenge needed for some torrent sites)
- **qbittorrent**   -    (downloads torrents)
- **Overseerr** -    (Used to trigger searches for media. aka, a search function for shows/movies)
- **Ombi**  -    (Same as overseerr, but wouldnt work for me)


---

# Server Setup
This is in rough order, but dont take my word for it 100%, as this is cobbled together as I added services while building.

## Server
Run the `localvolumes.sh` script to create the necessary volumes.\
I have the folders it creates perms set as 776. arguably not the tightest but its what works for me, and this isnt being accessed outside my local network. YMMV.

I recommend running this stack for 5 mins, then uninstalling it, just so we have all the config present in a cold state. This is important for qbittorrent as you have to add some config.

FWIW, I am running this on a k3s cluster with the default calico networking. [See here](docs/1-cluster.md)

I am running this on an 8G RAM, i5 8500 SFFPC with integrated graphics. 16+gig would be ideal, but this works ok.

## Networking
I also have a VPN configured at network level so all external queries from the server are sent via VPN. [See here](https://support.nordvpn.com/hc/en-us/articles/20280525082001-Setting-up-TP-Link-with-NordVPN) for how this works for me (TP-Link + NordVPN).

When setting up services, use the local IP address with assigned nodeport (in values.yaml) rather than hostname/localhost/externalIP.

In my routers DHCP I have my servers local IP set to static (192.168.1.155 for me)

I have a pi-hole for DNS, so i can assign local domain names. 


# Stack Setup

## Qbittorrent
(Start with the stack switched off)
1. Add in `WebUI\HostHeaderValidation=false` into the qBittorrent.conf
2. Start the stack. you can now sign in using the credentials in the pod logs.
    - if this doesnt work, try add `WebUI\Password_PBKDF2="@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)"`. this will set the username/pwd to admin/adminadmin.
3. Change the username/password
4. Settings I changed:
    1. delete .torrent files after (enabled)
    2. default torrent management mode (automatic)
    3. when torrent category changed (relocate torrent)
    4. when default save path changed (relocate affected torrents)
    5. when category save path changed (relocate affected torrents)
    6. use subcategories (enabled)
    7. set the paths to our media directory (/data/media)
    8. hit the random button for a random port


## Plex
1. Follow the generic setup wizard. 
2. Ensure your plex server is claimed.
3. Add the tv/movie librarys for media.

## Sonarr/Radarr
These services are pretty much identical, so do the same for both.
1. Disable auth for local addresses.
2. Add qbittorrent as a download client

## Prowlarr
1. Disable auth for local addresses.
2. Add flaresolver under Indexer Proxies, add a tag for `flaresolverr`
3. Add qbittorrent as a download client
4. Add radarr/sonarr under Apps (Their API keys can be found on Radarr/Sonarr under `Settings/General/Security)
5. Add some indexers. If the indexer requires cloudflare (flaresolverr), add the tag `flaresolverr`

## Overseerr
1. Follow the setup wizard (sign in with plex, add libraries, add sonarr/radarr, etc..)
