# 🐳 LEMP Stack + Zabbix Agent2

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange.svg)](https://ubuntu.com/)
[![PHP](https://img.shields.io/badge/PHP-8.3-777BB4.svg)](https://php.net/)
[![Nginx](https://img.shields.io/badge/Nginx-1.24-green.svg)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1.svg)](https://mysql.com/)
[![Zabbix](https://img.shields.io/badge/Zabbix-7.4-red.svg)](https://www.zabbix.com/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)

**Complete LEMP development environment in Docker with Zabbix Agent2 7.4 for monitoring tests and PHP application development.**

## ✨ Features

- 🏗️ **Complete LEMP Stack** - Ubuntu 24.04, Nginx, PHP 8.3, MySQL 8.0
- 📊 **Zabbix Agent2 7.4** - Advanced monitoring from official repository
- 🚀 **Quick Start** - One command to bring up the entire stack
- 🔧 **No Supervisor** - Native systemd services for maximum simplicity
- 🌐 **Alternative Ports** - Compatible with Laravel Herd on macOS
- 📱 **Web Dashboard** - Testing interface with service status
- 💾 **MySQL Persistence** - Data preserved between restarts
- 🐛 **Integrated Debugging** - Built-in logs and diagnostic tools

## 🚀 Quick Start

```bash
# Clone/access project directory
cd /path/to/project

# Copy environment configuration (optional)
cp env.example .env

# Build and start the stack
docker-compose up --build

# Or run in background
docker-compose up --build -d
```

**Web Access:** http://localhost:8081 (o el puerto configurado en NGINX_HTTP_PORT)

## 📋 Requirements

- Docker and Docker Compose
- Available ports: 8081, 8444, 3307, 10050 (configurables via variables de entorno)
- (Optional) Zabbix Server running on localhost:10051

## 🏗️ Architecture

**Included Stack:**
- **Ubuntu 24.04** with native systemd
- **Nginx 1.24.0** (port 8081)
- **PHP 8.3-FPM** with common extensions
- **MySQL 8.0** (port 3307)
- **Zabbix Agent2 7.4** (port 10050)

**Port Mapping (configurable via variables de entorno):**
- `${NGINX_HTTP_PORT:-8081}` → Nginx HTTP (avoids conflict with Herd:80)
- `${NGINX_HTTPS_PORT:-8444}` → Nginx HTTPS (avoids conflict with Herd:443)
- `${MYSQL_PORT:-3307}` → MySQL (avoids conflict with Herd:3306)
- `${ZABBIX_AGENT_PORT:-10050}` → Zabbix Agent

## 🛠️ Useful Commands

### Stack Management
```bash
# Start services
docker-compose up -d

# View logs in real time
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild from scratch
docker-compose down && docker-compose up --build

# Access container
docker exec -it lemp-zabbix-test bash
```

### Service Management (inside container)
```bash
# Service status
docker exec lemp-zabbix-test service nginx status
docker exec lemp-zabbix-test service php8.3-fpm status
docker exec lemp-zabbix-test service mysql status
docker exec lemp-zabbix-test service zabbix-agent2 status

# Restart services
docker exec lemp-zabbix-test service nginx restart
docker exec lemp-zabbix-test service mysql restart
docker exec lemp-zabbix-test service zabbix-agent2 restart
```

### Debugging
```bash
# View service logs
docker exec lemp-zabbix-test tail -f /var/log/nginx/error.log
docker exec lemp-zabbix-test tail -f /var/log/zabbix/zabbix_agent2.log

# Test Zabbix configuration
docker exec lemp-zabbix-test zabbix_agent2 -t

# Connect to MySQL
docker exec lemp-zabbix-test mysql -u testuser -ptestpass testdb
```

## 📁 Project Structure

```
/
├── docker-compose.yml          # Main orchestration
├── Dockerfile                  # LEMP stack image
├── nginx/default.conf          # Nginx configuration
├── zabbix/zabbix_agent2.conf  # Zabbix configuration
├── scripts/init.sh            # Initialization script
├── www/                       # Web files
│   ├── index.php             # Main dashboard
│   ├── test-mysql.php        # Detailed MySQL test
│   └── phpinfo.php           # PHP information
├── logs/                      # Application logs
└── mysql/data/               # Persistent MySQL data
```

## 🔧 Configuration

### Variables de Entorno
Copia `env.example` a `.env` y modifica los valores según tus necesidades:

```bash
cp env.example .env
```

### MySQL (configurable via variables de entorno)
- **Root**: `${MYSQL_USER:-root}` / `${MYSQL_ROOT_PASSWORD:-root123}`
- **User**: `${MYSQL_USER:-testuser}` / `${MYSQL_PASSWORD:-testpass}`
- **Database**: `${MYSQL_DATABASE:-testdb}`

### Zabbix Agent2 (configurable via variables de entorno)
- **Server**: `${ZABBIX_SERVER:-host.docker.internal}` (your Mac)
- **Port**: `${ZABBIX_SERVER_PORT:-10051}` (server) / `${ZABBIX_AGENT_PORT:-10050}` (agent)
- **Hostname**: `lemp-test-host`

## 🌐 Test Pages

- **Main Dashboard**: http://localhost:${NGINX_HTTP_PORT:-8081}
- **MySQL Test**: http://localhost:${NGINX_HTTP_PORT:-8081}/test-mysql.php
- **PHP Info**: http://localhost:${NGINX_HTTP_PORT:-8081}/phpinfo.php

## 🔍 Troubleshooting

### Container won't start
```bash
# View detailed logs
docker-compose logs

# Check ports in use (reemplaza 8081 con tu puerto configurado)
lsof -i :8081
lsof -i :10050  # Verificar puerto Zabbix Agent
```

### MySQL won't connect
```bash
# Check status
docker exec lemp-zabbix-test service mysql status

# Reinitialize data (CAUTION: deletes data)
docker-compose down
rm -rf mysql/data/*
docker-compose up --build
```

### Zabbix Agent not working
```bash
# Check configuration
docker exec lemp-zabbix-test zabbix_agent2 -t

# View logs
docker exec lemp-zabbix-test tail -f /var/log/zabbix/zabbix_agent2.log
```

### Permission errors
```bash
# Restart with clean permissions
docker-compose down
docker system prune -f
docker-compose up --build
```

## 🎯 Purpose

This environment is designed for:
- LEMP development testing
- Zabbix configuration testing
- PHP application development
- Application monitoring and metrics

**Note**: This is a development/testing environment, not for production.

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Report Issues

If you find a bug or have a suggestion:

1. Check that a similar issue doesn't exist
2. Open a new issue with detailed description
3. Include steps to reproduce the problem
4. Attach relevant logs if possible

## 📝 Technical Notes

- **Architecture**: Native Ubuntu systemd services (no supervisor)
- **Persistence**: MySQL data in `./mysql/data/`
- **Networking**: Host networking for Zabbix server compatibility
- **Configuration**: Optimized for development and testing
- **Compatibility**: Designed for macOS with Laravel Herd

## 📋 Roadmap

- [ ] HTTPS support with self-signed certificates
- [ ] Optional included Zabbix server configuration
- [ ] MySQL backup/restore scripts
- [ ] Additional monitoring with Prometheus
- [ ] Docker multi-stage builds for optimization

## 📄 License

This project is under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

Developed with ❤️ for the PHP development and DevOps community.

---

⭐ **If this project was useful to you, give it a star!** ⭐