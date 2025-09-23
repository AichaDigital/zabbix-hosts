#!/bin/bash

echo "Iniciando servicios LEMP..."

# Configurar MySQL si es la primera vez
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "Configurando MySQL..."

    # Iniciar MySQL sin systemd para configuración inicial
    service mysql start
    sleep 10

    # Configurar base de datos
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DATABASE};"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

    touch /var/lib/mysql/.initialized
    echo "MySQL configurado"
    service mysql stop
    sleep 2
fi

# Crear directorios necesarios
mkdir -p /var/log/zabbix /var/run/zabbix

# Ajustar permisos
chown mysql:mysql /var/lib/mysql /var/run/mysqld
chown zabbix:zabbix /var/run/zabbix /var/log/zabbix
chown www-data:www-data /var/www/html

# Iniciar servicios con service (compatible con systemd)
echo "Iniciando servicios..."
service mysql start
service nginx start
service php8.3-fpm start
service zabbix-agent2 start

# Verificar que los servicios están corriendo
echo "Verificando servicios..."
service mysql status
service nginx status
service php8.3-fpm status
service zabbix-agent2 status

echo "Todos los servicios iniciados. Container listo."
echo "Acceso web: http://localhost:8081"

# Mantener el container corriendo
tail -f /var/log/nginx/access.log /var/log/nginx/error.log