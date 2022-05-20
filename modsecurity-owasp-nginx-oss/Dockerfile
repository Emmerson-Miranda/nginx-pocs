FROM owasp/modsecurity:3.0.3
MAINTAINER emmerson.miranda@gmail.com

#Emmerson: Coping files
COPY ./etc/ /etc/
RUN ls -la /etc/*


EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
