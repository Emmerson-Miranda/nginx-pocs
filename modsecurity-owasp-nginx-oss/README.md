# About this Project
This project is a POC to show how to integrate WAF capabilities (ModSecurity) with Nginx Open Source.

Features:
- This project use OWASP CRS and enable PARANOIA level 2 only only for demo purposes
- Create and register a custom rule 
- Provide a shell script to test the image
- Provide a small JMeter project
- Does not do passthrought (proxy), instead of that return:
  - 200 with a payload composed by URI, HTTP Headers and parameters (not body) of the original request (using JavaScript module)
  - 400 if payload does not match with Content-Type
  - 403 is WAF detect an attack


## Components

This project is based on image owasp/modsecurity:3.0.3 and contains
- Nginx OSS
- ModSecurity 3.0.3
- OWASP ModSecurity CRS 3.2.0
- Demo custom rules


## Running the image

docker run -ti -p 80:80 -e modsecurity-owasp-nginx-oss:v1


## Logs

Get container ID

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                         NAMES
d38f0f24e071        my-waf:v1           "nginx -g 'daemon of…"   8 seconds ago       Up 7 seconds        0.0.0.0:80->80/tcp, 443/tcp   fervent_volhard
```

Accessing to the image

```
$ docker exec -it d38f0f24e071  /bin/bash
```

Reading logs

```
root@d38f0f24e071:/# tail -f /var/log/modsec_audit.log
```


## Docker image documentation

[Please visit Docker Hub Location](https://hub.docker.com/repository/docker/emmerson/modsecurity-owasp-nginx-oss)
