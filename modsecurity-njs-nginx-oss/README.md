# About this Project
---
This project is a POC to show how to integrate WAF capabilities (ModSecurity) with Nginx Open Source and NJS (NGINX JavaScript).

This project is inspired on https://hub.docker.com/r/owasp/modsecurity-crs

Features:
- This project use OWASP CRS and enable PARANOIA level 2 only only for demo purposes
- Provide a shell script to test the image
- Does not do passthrought (proxy), instead of that return:
  - 200 with a payload composed by URI, HTTP Headers and parameters (not body) of the original request (using JavaScript module)
  - 400 if payload does not match with Content-Type
  - 403 is WAF detect an attack

## Components

This project is based on image owasp/modsecurity:3.0.3 and contains
- Nginx OSS
- ModSecurity 
- OWASP ModSecurity CRS 
- Demo NJS


## Build and run the image

Run [build.sh file](./misc/build.sh)

## Test the image

In a separate terminal run [modsecurity-checks.sh file](./misc/modsecurity-checks.sh)


## Logs

Get container ID

```
% docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS          PORTS                                      NAMES
386e0a2bed8b   modsecurity-njs-nginx-oss:1.0.0   "/docker-entrypoint.…"   21 minutes ago   Up 21 minutes   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   blissful_cohen
```

Accessing to the image

```
% docker exec -it 386e0a2bed8b  /bin/bash
```
