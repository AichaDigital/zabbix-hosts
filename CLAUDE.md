# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a LEMP (Linux + Nginx + PHP + MySQL) stack Docker environment designed for testing with a Zabbix monitoring server. The entire stack runs in a single container to avoid port conflicts with Laravel Herd on macOS.

## Architecture

- **Single Container LEMP Stack**: Ubuntu 24.04 with Nginx, PHP-FPM, MySQL, and Zabbix Agent
- **Purpose**: Testing environment for a local Zabbix server (localhost:8080)
- **Port Mapping**: Alternative ports to avoid conflicts with Herd (80→8081, 443→8444, 3306→3307)
- **Zabbix Integration**: Agent configured to communicate with host Zabbix server on ports 10050/10051

## Common Commands

### Development and Testing
```bash
# Build and start the container
docker-compose up --build

# Start in background
docker-compose up -d

# Stop the container
docker-compose down

# View logs
docker-compose logs -f

# Access container shell
docker exec -it lemp-zabbix-test bash

# Restart specific service inside container
docker exec -it lemp-zabbix-test service nginx restart
docker exec -it lemp-zabbix-test service php8.3-fmp restart
docker exec -it lemp-zabbix-test service mysql restart
docker exec -it lemp-zabbix-test service zabbix-agent2 restart
```

### Monitoring and Debugging
```bash
# Check all services status
docker exec -it lemp-zabbix-test service nginx status
docker exec -it lemp-zabbix-test service php8.3-fpm status
docker exec -it lemp-zabbix-test service mysql status
docker exec -it lemp-zabbix-test service zabbix-agent2 status

# Check Zabbix agent status
docker exec -it lemp-zabbix-test zabbix_agent2 -t

# Test MySQL connection (when working)
docker exec -it lemp-zabbix-test mysql -u testuser -ptestpass testdb

# View service logs
docker exec -it lemp-zabbix-test tail -f /var/log/nginx/error.log
docker exec -it lemp-zabbix-test tail -f /var/log/zabbix/zabbix_agent2.log
```

## Access Points

- **Web Server**: http://localhost:8081
- **MySQL**: localhost:3307 (root/root123, testuser/testpass)
- **Zabbix Agent**: localhost:10050
- **Test Pages**: 
  - http://localhost:8081 (main dashboard)
  - http://localhost:8081/test-mysql.php (MySQL connectivity test)
  - http://localhost:8081/phpinfo.php (PHP configuration)

## File Structure

```
/
├── docker-compose.yml          # Main container orchestration
├── Dockerfile                  # LEMP stack image definition
├── nginx/default.conf          # Nginx virtual host configuration
├── zabbix/zabbix_agent2.conf  # Zabbix agent2 configuration
├── scripts/init.sh            # Container initialization script
├── www/                       # Web root directory
├── logs/                      # Application logs
└── mysql/data/               # MySQL data persistence
```

## Configuration Notes

- **Services**: Native Ubuntu systemd services using `service` command
- **MySQL**: Auto-initializes with testdb database and testuser (currently needs troubleshooting)
- **Zabbix**: Agent2 7.4.x configured to connect to host.docker.internal (macOS Docker Desktop)
- **PHP**: Ubuntu 24.04 default PHP 8.3 with common extensions
- **Persistence**: MySQL data persisted in ./mysql/data volume

## Zabbix Integration

The container is configured as a Zabbix agent client:
- Server: host.docker.internal (your Mac running Zabbix server)
- Port: 10051 (Zabbix server port)
- Agent Port: 10050 (exposed for monitoring)
- Hostname: lemp-test-host

Custom user parameters included for web server monitoring (nginx status, PHP version, MySQL status, system metrics).

## Troubleshooting

- Check supervisor status if services aren't running
- Verify port availability on host (8081, 8444, 3307, 10050)
- Ensure Zabbix server is accessible on host.docker.internal
- Check logs in ./logs/ directory for detailed error information
- to memorize