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

WAF is only monitoring the root context path
````
% curl -d ""  -H "Content-Type: application/json" -i  -X "GET" "http://localhost/?exec=/bin/bash"
HTTP/1.1 403 Forbidden
Server: nginx/1.20.2
Date: Sat, 21 May 2022 23:14:28 GMT
Content-Type: text/html
Content-Length: 153
Connection: keep-alive

<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.20.2</center>
</body>
</html>
````

If you attack on the same way to /fs/ path WAF is not triggered.
````
% curl -d ""  -H "Content-Type: application/json" -i  -X "GET" "http://localhost/fs/?exec=/bin/bash"
HTTP/1.1 200 OK
Server: nginx/1.20.2
Date: Sat, 21 May 2022 23:14:14 GMT
Content-Type: text/html
Transfer-Encoding: chunked
Connection: keep-alive

<html>
<head><title>Index of /fs/</title></head>
<body>
<h1>Index of /fs/</h1><hr><pre><a href="../">../</a>
<a href="bin/">bin/</a>                                               09-May-2022 00:00                   -
<a href="boot/">boot/</a>                                              19-Mar-2022 13:46                   -
<a href="dev/">dev/</a>                                               21-May-2022 23:11                   -
<a href="docker-entrypoint.d/">docker-entrypoint.d/</a>                               17-May-2022 12:36                   -
<a href="etc/">etc/</a>                                               21-May-2022 23:11                   -
<a href="home/">home/</a>                                              19-Mar-2022 13:46                   -
<a href="lib/">lib/</a>                                               09-May-2022 00:00                   -
<a href="lib64/">lib64/</a>                                             09-May-2022 00:00                   -
<a href="media/">media/</a>                                             09-May-2022 00:00                   -
<a href="mnt/">mnt/</a>                                               09-May-2022 00:00                   -
<a href="opt/">opt/</a>                                               17-May-2022 12:36                   -
<a href="proc/">proc/</a>                                              21-May-2022 23:11                   -
<a href="root/">root/</a>                                              09-May-2022 00:00                   -
<a href="run/">run/</a>                                               21-May-2022 23:11                   -
<a href="sbin/">sbin/</a>                                              09-May-2022 00:00                   -
<a href="srv/">srv/</a>                                               09-May-2022 00:00                   -
<a href="sys/">sys/</a>                                               21-May-2022 23:11                   -
<a href="tmp/">tmp/</a>                                               16-May-2022 12:19                   -
<a href="usr/">usr/</a>                                               09-May-2022 00:00                   -
<a href="var/">var/</a>                                               09-May-2022 00:00                   -
<a href="docker-entrypoint.sh">docker-entrypoint.sh</a>                               11-May-2022 05:05                1202
</pre><hr></body>
</html>
````



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
