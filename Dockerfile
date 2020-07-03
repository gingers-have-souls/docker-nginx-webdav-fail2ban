FROM alpine

RUN apk update && apk upgrade \
	&& apk add nginx nginx-mod-http-dav-ext fail2ban \
	&& mkdir -p /run/nginx \
	&& rm /etc/nginx/conf.d/* \
	&& mkdir -p /var/www/webdav \
	&& chown nginx:nginx /var/www/webdav \
	&& mkdir -p /tmp/nginx/client-bodies \
	&& mkdir -p /run/fail2ban \
	&& rm /etc/fail2ban/jail.d/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d/
COPY fail2ban-jails.conf /etc/fail2ban/jail.d/

VOLUME [ "/var/www/webdav" ]

EXPOSE 80

CMD ["sh", "-c", "nginx && fail2ban-server -fv start"]
