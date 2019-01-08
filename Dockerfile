# Heavily based on original Dockerfile by Calum Hunter (https://github.com/calum-hunter/munkireport-docker).
# MR-PHP Version 4.0.1
FROM ubuntu

# The version of Munki report to download
ENV MR_VERS v4.0.1.tar.gz

# Set Environmental variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ Canada/Vancouver

# Set Env variables for Munki Report Config
ENV DB_NAME munkireport
ENV MR_SITENAME MunkiReport
ENV MR_TIMEZONE Canada/Vancouver

# Define proxy setting variables for Munki report
# set this to mod1, mod2 or no depending upon your proxy server needs. See the Readme for more info.
ENV proxy_required no
ENV proxy_server proxy.example.com
ENV proxy_uname proxyuser
ENV proxy_pword proxypassword
ENV proxy_port 8080

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get install -y language-pack-en-base
RUN LC_ALL=C.UTF-8 apt-add-repository ppa:ondrej/php

# Install base packages for MR
# php-dom instead of php-xml
RUN apt-get update && \
	apt-get -y install \
	nginx-extras \
	git \
	nano \
	php \
	php-xml \
	php-mbstring \
	zip \
	unzip \
    php7.2-fpm \
	php7.2-zip \
	php7.2-mysql \
	php7.2-ldap \
	curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer 

# Make folder for enabled sites in nginx
# Add line to php config to prevent blank page, fix PHP CGI pathinfo
RUN mkdir -p /www/munkireport && \
	mkdir -p /etc/nginx/sites-enabled/ && \
	rm -rf /etc/nginx/sites-enabled/* && \
	rm -rf /etc/nginx/nginx.conf 

# Grab our Munki Report Release defined in MR_VERS from Github, unpack it and remove the tarball
ADD https://github.com/munkireport/munkireport-php/archive/$MR_VERS /www/munkireport/$MR_VERS
RUN tar -zxvf /www/munkireport/$MR_VERS --strip-components=1 -C /www/munkireport && \
	rm /www/munkireport/$MR_VERS

RUN composer install --working-dir=/www/munkireport --no-dev --no-suggest --optimize-autoloader

# Add our nginx configs
ADD confs/munki-report.conf /etc/nginx/sites-enabled/munki-report.conf
ADD confs/nginx.conf /etc/nginx/nginx.conf

# Set up logs to output to stout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

# Add our startup script
ADD start.sh /start.sh
RUN chmod +x /start.sh

# Expose Ports
EXPOSE 80

# Run our startup script
CMD bash -C '/start.sh'; 'bash'
