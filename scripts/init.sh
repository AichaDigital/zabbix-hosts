#!/bin/bash

echo "Starting LEMP services..."

# Configure MySQL if first time
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "Configuring MySQL..."

    # Start MySQL without systemd for initial configuration
    service mysql start
    sleep 10

    # Configure database
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DATABASE};"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

    touch /var/lib/mysql/.initialized
    echo "MySQL configured"
    service mysql stop
    sleep 2
fi

# Create necessary directories
mkdir -p /var/log/zabbix /var/run/zabbix

# Adjust permissions
chown mysql:mysql /var/lib/mysql /var/run/mysqld
chown zabbix:zabbix /var/run/zabbix /var/log/zabbix
chown www-data:www-data /var/www/html

# Start services with service command (systemd compatible)
echo "Starting services..."
service mysql start
service nginx start
service php8.3-fpm start
service zabbix-agent2 start

# Verify services are running
echo "Verifying services..."
service mysql status
service nginx status
service php8.3-fpm status
service zabbix-agent2 status

echo "All services started. Container ready."
echo "Web access: http://localhost:8081"

# Keep container running
tail -f /var/log/nginx/access.log /var/log/nginx/error.log