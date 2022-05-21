FROM owasp/modsecurity-crs:3.3.2-nginx
LABEL MAINTAINER="emmerson.miranda@gmail.com"

#Emmerson: Coping files
COPY ./etc/nginx/ /etc/nginx/
#RUN ls -la /etc/nginx/*


EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
