#!/bin/bash
CONSUL_TEMPLATE_VERSION="${1:-0.29.0}"
CONTAINER_TAG="${2:-1.1}"
CONTAINER_RELEASE_BUILD="${3:-true}"

echo "CONSUL_TEMPLATE_VERSION: ${CONSUL_TEMPLATE_VERSION}"
echo "DOCKER TAG: ${CONTAINER_TAG}"
echo "RELEASE BUILD: ${CONTAINER_RELEASE_BUILD}"

wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip
unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

docker build --build-arg CONSUL_TEMPLATE_VERSION=${CONSUL_TEMPLATE_VERSION} --tag "nginx-consul-template:${CONTAINER_TAG}"  --no-cache=true . 
cat build.log

if [ $CONTAINER_RELEASE_BUILD == true ]; then
	docker build --build-arg CONSUL_TEMPLATE_VERSION=${CONSUL_TEMPLATE_VERSION} --tag "nginx-consul-template:latest"  --no-cache=true .
fi

rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.*
rm consul-template

echo "Build finished, now you can run:  "
echo "docker run  -p 80:80 -p 443:443 -dit nginx-consul-template"
echo "or"
echo "docker run  -p 80:80 -p 443:443 -dit --env ENABLE_CONSUL_TEMPLATE=true nginx-consul-template"

echo "-------------------"
IMAGE_ID=$(docker images -q "nginx-consul-template:${CONTAINER_TAG}") 
echo "IMAGE_ID:$IMAGE_ID"
echo "docker tag ${IMAGE_ID} emmerson/nginx-consul-template:${CONTAINER_TAG}"
echo "docker push emmerson/nginx-consul-template:${CONTAINER_TAG}"
echo "-------------------"
echo ""
# checking docker template is inside the image
# docker exec -it 1fb7a6335931 /bin/ls /usr/local/bin