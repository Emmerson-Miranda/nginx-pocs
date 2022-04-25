#!/bin/bash
ENABLE_CONSUL_TEMPLATE="${ENABLE_CONSUL_TEMPLATE:-false}"

date

if [ "$ENABLE_CONSUL_TEMPLATE" == "true" ]
then
    echo "Starting NGINX with Consul template"
    #service nginx start & consul-template -template="/templates/service.ctmpl:/etc/nginx/conf.d/service.conf:service nginx reload"
    nginx -g 'daemon off;' & consul-template -config "/opt/poc/consul-template/template.hcl" 
else
    echo "Starting NGINX without Consul template because ENABLE_CONSUL_TEMPLATE is $ENABLE_CONSUL_TEMPLATE instead of  'true'."
    #service nginx start 
    nginx -g 'daemon off;'
fi

