---
title: "Self Hosting solution"
weight: 1
type: docs
summary: How I manage my website and its services
---

This website and my various services are hosted using various technologies.

Every service that is exposed to the internet is run through the Cloudflare reverse proxy to ensure upmost security without exposing my IP Address to the masses. It also handles delivering assets as fast as possible to anywhere around the world.

My server box at home uses docker containers for its various services and is backed by traefik to handle the routing. Traefik is configured to route the docker container ports to the internet for public acces on its various subdomains. SSL is provided via LetsEncrypt to ensure security without requiring an SSL certificate for each independant service. As well as handle the edge routing, Traefik automatically refreshes the SSL certificate before it expires, therefore reducing downtime of the server without user intervention.
