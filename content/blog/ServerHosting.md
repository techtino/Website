---
title: Self Hosting solution
weight: 1
type: docs
summary: How my homelab works (docker, traefik, cloudflare tunnel)
---
## Intro
Running a homelab can teach you a lot about networking, systems administration, devops and so on. This post is intended to give you a vague idea on what your homelab might look like if you choose to go down that path.
## Server
My home server is an assortment of random components I've gathered over the years. Depending on what you choose to run on your server, you can build it as powerful as you see fit. For my case I'm rocking:
- Ryzen 9 3900x
- 24GB Ram
- AMD RX 550 (rarely used!)
- 10 gigabit NIC

I am currently running Debian, but historically I have run Ubuntu Server, Rocky linux (at one point I was running fedora, no idea why!). Point being, it doesn't really matter what OS I run as everything is containerised rather than running baremetal on the OS itself.

I will note that it's definitely recommended to stick to something well known and stable of course. Debian is a great contender for this as it's long-standing, and Debian stable (as the name implies) is stable, and has a record of not creaking/breaking under pressure.
### Docker!
My server at home uses docker containers for its various services. I have one massive (ugly!) monolithic docker-compose yaml which contains all of my services.

The power of Docker (and by extension docker-compose), is that you can simply take your docker-compose and its volumes, zip it up/back it up somewhere, and place it on a new server, and it will 'just work'. 
I personally back up my container volumes and docker-compose to my NAS. I have a helper script which simply mounts my NAS via NFS, pulls the latest copy of my containers backup and setups up a systemd service to run docker-compose up for me. https://github.com/techtino/server-setup. It's an incredibly naive setup, but it works perfectly for my use-case.

Here's a very basic example service in my docker-compose yaml.
```
    whoami:
        image: traefik/whoami
        command:
        # It tells whoami to start listening on 2001 instead of 80
        - --port=2001
        - --name=iamfoo
        labels:
            - "traefik.enable=true"
            - "traefik.http.services.whoami.loadbalancer.server.port=2001"
            - "traefik.http.routers.whoami.rule=Host(`whoami.techtino.co.uk`)"
            - "traefik.http.routers.whoami.entrypoints=websecure"
            - "traefik.http.routers.whoami.tls.certresolver=myresolver"
            - "traefik.http.routers.whoami.middlewares=traefik-forward-auth"
```
All docker does is pull down the whoami image from dockerhub and run it with a few parameters (port and name). You'll notice lots of labels! I'll go over what these do later.
### Traefik
Traefik is a reverse proxy which is tailored towards containerised workloads. Traefik can discover containers and act as a frontend for them. This means you do not need to individually expose each service outside the docker networking stack if they don't need to be.

Here's what my traefik configuration looks like in docker-compose:
```
traefik:
        image: "traefik:latest"
        container_name: "traefik"
        command:
            #- "--log.level=DEBUG"
            - "--api.insecure=true"
            - "--providers.docker=true"
            - "--providers.docker.exposedbydefault=false"
            - "--entrypoints.websecure.address=:443"
            - "--certificatesresolvers.myresolver.acme.dnschallenge=true"
            - "--certificatesresolvers.myresolver.acme.dnschallenge.provider=cloudflare"
            - "--certificatesresolvers.myresolver.acme.email=xxxx"
            - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
            - "--serversTransport.insecureSkipVerify=true"
            - "--metrics.prometheus=true"
        ports:
            - "443:443"
            - "8081:8080"
        volumes:
            - "./letsencrypt:/letsencrypt"
            - "/var/run/docker.sock:/var/run/docker.sock"
        environment:
            - "CF_API_EMAIL=xxxx"
            - "CF_DNS_API_TOKEN=******"
        restart: always
        depends_on:
            - sonarr
            - radarr
            - jellyfin
            - portainer
            - nextcloud
            - collabora
        extra_hosts:
            - "host.docker.internal:172.17.0.1"
```

I'm aware this is a fairly verbose example! Lets break it down.
#### Misc Flags
It starts traefik with a few command arguments. We enable the docker provider so Traefik can discover our containers, then we configure the websecure entrypoint to 443 (so users can access services via a TLS backed URL without specifying a custom port). We also enable a few nice to haves.
#### ACME flags
Following that, we tell Traefik that it can use ACME to generate new SSL certificates when they are close to expiry. Traefik knows how to regenerate the letsencrypt acme json and uses cloudflare to complete a dns acme challenge. Better explanations can be found here: https://doc.traefik.io/traefik/expose/docker/#generate-certificates-with-lets-encrypt and here https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/acme/. This requires the CF environment variables to be set so traefik can talk to cloudflare on my behalf.
#### Ports
You can see the ports 443 and 8081 are exposed. 443 is for my websecure entrypoint, and 8081 takes me to the traefik console. (8080 is used by another service so it's been mapped to 8081 on the outside).
#### Volumes
We expose a directory for traefik to use for letsencrypt acme processes. This ensures the acme json is not destroyed inside the container if we accidentally/intentionally regenerate the container.
We additionally expose the host's docker socket so that traefik is able to communicate via the socket to find exposed services.
### Auth Middleware
Traefik can be tied into an auth middleware to harden access towards services which only have basic/no auth. I personally use https://github.com/thomseddon/traefik-forward-auth backed with google oauth.
```
traefik-forward-auth:
        image: thomseddon/traefik-forward-auth:2
        container_name: traefik-forward-auth
        environment:
            - PROVIDERS_GOOGLE_CLIENT_ID=xxxx
            - PROVIDERS_GOOGLE_CLIENT_SECRET=xxxx
            - SECRET=xxxx
            - LOG_LEVEL=debug
            - WHITELIST=xxxx
        labels:
            - "traefik.enable=true"
            - "traefik.http.middlewares.traefik-forward-auth.forwardauth.address=http://traefik-forward-auth:4181"
            - "traefik.http.middlewares.traefik-forward-auth.forwardauth.authResponseHeaders=X-Forwarded-User"
            - "traefik.http.services.traefik-forward-auth.loadbalancer.server.port=4181"
        depends_on:
            - traefik
        restart: always
```
Again, read their docs for more clarity, but lets break it down.
#### Environment
We provide the container with our google client id and client secret, and additional custom secret, as generated per docs: https://github.com/thomseddon/traefik-forward-auth/wiki/Provider-Setup, set a debug log level, and set a whitelist such that it only accepts auth attempts from my email.
#### Labels
We enable traefik for the service, create a new middleware 'traefik-forward-auth' and define the address. Traefik will know to internally use this address to process auth requests. Once traefik-forward-auth does its thing, it'll return an X-Forwarded-User header which Traefik/underlying apps are configured to use to verify a users identity/if they've authed correctly.
### Tying it in with a service
Traefik knows how to pick up labels from docker and use those to generate reverse proxy configuration for a 'service' and 'router'. For a better explanation, see their own docs here: https://doc.traefik.io/traefik/reference/routing-configuration/other-providers/docker/

Snippet from the 'whoami' example:
```
	labels:
		- "traefik.enable=true"
		- "traefik.http.services.whoami.loadbalancer.server.port=2001"
		- "traefik.http.routers.whoami.rule=Host(`whoami.techtino.co.uk`)"
		- "traefik.http.routers.whoami.entrypoints=websecure"
		- "traefik.http.routers.whoami.tls.certresolver=myresolver"
		- "traefik.http.routers.whoami.middlewares=traefik-forward-auth"
```
The labels in my above whoami example are very simple. It tells traefik to create a new service 'whoami' (traefik.http.services.whoami) and a new router (traefik.http.routers.whoami). Traefik is informed that the service should expose port 2001 from inside the container. The router configuration tells traefik to direct clients to the service by the same name (whoami) if the client is specifying a request url or a host header of 'whoami.techtino.co.uk'. We then tell traefik to use the 'websecure' entrypoint, which is port 443. We also configure a TLS Cert resolver and middleware for authentication.
### Exposing to the internet
A selection of services are exposed to the internet. Cloudflare tunnel (https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/) is used to manage this. This tunnels traffic via Cloudflare's servers as opposed to opening ports locally and exposing it via your firewall/router. This has some security benefits (guaranteed masked IP address). It also gets around a pesky limitation of Carrier Grade NAT not allowing opening ports. One thing to note is that CloudFlare's TOS does not permit you to stream media over the tunnel. The tunnel is used to stream web elements only, and for cases of media streaming, I resort to tailscale.

As briefly touched on, Cloudflare is being used to provide DNS management. The tunnel is simply configured as a wildcard `*.techtino.co.uk` CNAME which redirects to the my cloudflare tunnel dns record. Cloudflare docs on how to configure it can be found here: https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/routing-to-tunnel/dns/.

Backing everything with cloudflares dns and cdn management capabilities also ensures web assets are quick to load from anywhere, and you get all of the regular protections Cloudflare provides.
## Tailscale setup
In addition to exposing resources to the internet via cloudflare tunnel, there is also the ability to use Tailscale to provide direct access to your home network. Personally, I use tailscale to access my local server, NAS, router, and other home resources that I am not comfortable exposing to the internet.

In my setup, I already have an Opnsense router/firewall which I am using to permit outbound internet access for my household. Opnsense now has a native Tailscale plugin, which hasn't been documented nicely anywhere, so here's a random reddit comment: https://www.reddit.com/r/opnsense/comments/1bo3y1k/comment/m39pt60/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button !

Once the plugin is installed, you can configure tailscale as you see fit. In my case, I configured authentication, and enabled subnet routing into my LAN (192.168.1.0/24), and added a default route out to the internet, in combination with enabling the 'Advertise exit node' feature.

On the tailscale admin portal, I have permitted my router as a subnet router and exit node, as well as added my router's IP as a global DNS server (I am running Unbound DNS in opnsense), and enabled 'Override DNS Servers'. This means that clients that connect to tailscale will use my home dns server and be able to access resources on my home network via its dns name and not have to remember ip's!
## Conclusion
There are many different ways you can choose to run a homelab, and there isn't a 'right choice'. 

I've personally found that over the years this setup has worked out for me, and is maintainable for my use-case. Docker lets me run services without concerns around dependency issues between OS releases, and in most cases updating a service is as simple as bumping the docker image tag. No messing with random tar.gz's or debian repos. It also wins me over by allowing my services to be portable.

Traefik integrates so nicely with docker that it didn't make sense to run other reverse proxy options. Traefik can simply work with docker labels and doesn't require custom config files dotted around the place. This also makes it entirely portable. In-fact, my traefik doesn't even have a volume to store its config in, as its generated entirely dynamically.

Tailscale won me over by being super user friendly. You could run a wireguard tunnel and get the same result, but are you going to ask users to setup wireguard on their laptop, or rather install tailscale and login with their google account.