FROM ubuntu:24.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Variables de entorno para MySQL
ENV MYSQL_ROOT_PASSWORD=root123
ENV MYSQL_DATABASE=testdb
ENV MYSQL_USER=testuser
ENV MYSQL_PASSWORD=testpass

# Instalar repositorio Zabbix 7.4 y paquetes necesarios
RUN apt-get update && apt-get install -y wget gnupg2 \
    && wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb \
    && dpkg -i zabbix-release_latest+ubuntu24.04_all.deb \
    && apt-get update \
    && apt-get install -y \
    nginx \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    php-bcmath \
    mysql-server \
    zabbix-agent2 \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f zabbix-release_latest+ubuntu24.04_all.deb

# Crear directorios necesarios
RUN mkdir -p /var/www/html /var/log/nginx /var/log/php /run/php

# Configurar PHP-FPM
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/*/fpm/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/php/*/fpm/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/php/*/fpm/php.ini \
    && sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php/*/fpm/php.ini

# Configurar Nginx
COPY nginx/default.conf /etc/nginx/sites-available/default

# Configurar MySQL
RUN mkdir -p /var/run/mysqld /var/lib/mysql \
    && chown mysql:mysql /var/run/mysqld /var/lib/mysql \
    && usermod -d /var/lib/mysql mysql

# Configurar Zabbix Agent2
COPY zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf

# Crear archivos web de prueba
COPY www/ /var/www/html/

# Permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Script de inicialización
COPY scripts/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 80 443 3306 10050

CMD ["/usr/local/bin/init.sh"]