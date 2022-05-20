# OWASP CRS
#docker run -ti -p 80:80 -e PARANOIA=5 -e PROXY=1 owasp/modsecurity-crs:nginx

#Backing the image
docker build -t modsecurity-owasp-nginx-oss:v1 ../.

#Run the image
docker run -ti -p 80:80 -e PARANOIA=2 -e PROXY=1 modsecurity-owasp-nginx-oss:v1
