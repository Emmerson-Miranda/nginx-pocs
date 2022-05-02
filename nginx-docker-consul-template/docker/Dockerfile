FROM nginx:latest

LABEL authors="Emmerson Miranda"

WORKDIR /etc/nginx

#RUN apt-get update 
RUN mkdir /opt/poc

# download the latest version of Consul Template and we put it on /usr/local/bin
ADD 	 ./consul-template /usr/local/bin/
COPY     ./opt/poc/ /opt/poc/

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 	80 11443

CMD ["/opt/poc/consul-template/start.sh"]
