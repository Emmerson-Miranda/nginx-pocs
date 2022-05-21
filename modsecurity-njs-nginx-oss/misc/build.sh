#!/bin/bash
CONTAINER_NAME="modsecurity-njs-nginx-oss"
CONTAINER_TAG="1.0.0"



docker build --tag "${CONTAINER_NAME}:${CONTAINER_TAG}"  --no-cache=true ../docker 


echo "Build finished, now you can run:  "
#echo "docker run  -p 80:80 -p 443:443 -dit ${CONTAINER_NAME}:${CONTAINER_TAG}"
echo "docker run  -p 80:80 -p 443:443 -ti ${CONTAINER_NAME}:${CONTAINER_TAG}"
echo "docker run  -p 80:80 -p 443:443 -ti ${CONTAINER_NAME}:${CONTAINER_TAG}" | pbcopy


echo "-------------------"
IMAGE_ID=$(docker images -q "${CONTAINER_NAME}:${CONTAINER_TAG}") 
echo "IMAGE_ID:$IMAGE_ID"
echo "docker tag ${IMAGE_ID} emmerson/${CONTAINER_NAME}:${CONTAINER_TAG}"
echo "docker push emmerson/${CONTAINER_NAME}:${CONTAINER_TAG}"
echo "-------------------"
echo ""
# checking docker template is inside the image
# docker exec -it 1fb7a6335931 /bin/ls /usr/local/bin

docker run  -p 80:80 -p 443:443 -e PARANOIA=2 -e PROXY=1 -ti  -v rules:/opt/owasp-crs/rules:ro --rm modsecurity-njs-nginx-oss:1.0.0
