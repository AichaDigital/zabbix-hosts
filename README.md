# 🐳 LEMP Stack + Zabbix Agent2

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange.svg)](https://ubuntu.com/)
[![PHP](https://img.shields.io/badge/PHP-8.3-777BB4.svg)](https://php.net/)
[![Nginx](https://img.shields.io/badge/Nginx-1.24-green.svg)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1.svg)](https://mysql.com/)
[![Zabbix](https://img.shields.io/badge/Zabbix-7.4-red.svg)](https://www.zabbix.com/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)

**Entorno de desarrollo LEMP completo en Docker con Zabbix Agent2 7.4 para pruebas de monitoreo y desarrollo de aplicaciones PHP.**

## ✨ Características

- 🏗️ **Stack LEMP completo** - Ubuntu 24.04, Nginx, PHP 8.3, MySQL 8.0
- 📊 **Zabbix Agent2 7.4** - Monitoreo avanzado desde repositorio oficial
- 🚀 **Inicio rápido** - Un comando para levantar todo el stack
- 🔧 **Sin supervisor** - Servicios nativos de systemd para máxima simplicidad
- 🌐 **Puertos alternativos** - Compatible con Laravel Herd en macOS
- 📱 **Dashboard web** - Interfaz de pruebas con estado de servicios
- 💾 **Persistencia MySQL** - Datos conservados entre reinicios
- 🐛 **Debugging integrado** - Logs y herramientas de diagnóstico incluidas

## 🚀 Inicio Rápido

```bash
# Clonar/acceder al directorio del proyecto
cd /ruta/al/proyecto

# Construir e iniciar el stack
docker-compose up --build

# O en segundo plano
docker-compose up --build -d
```

**Acceso web:** http://localhost:8081

## 📋 Requisitos

- Docker y Docker Compose
- Puertos disponibles: 8081, 8444, 3307, 10050
- (Opcional) Servidor Zabbix corriendo en localhost:8080

## 🏗️ Arquitectura

**Stack incluido:**
- **Ubuntu 24.04** con systemd nativo
- **Nginx 1.24.0** (puerto 8081)
- **PHP 8.3-FPM** con extensiones comunes
- **MySQL 8.0** (puerto 3307)
- **Zabbix Agent2 7.4** (puerto 10050)

**Puertos mapeados:**
- `8081` → Nginx HTTP (evita conflicto con Herd:80)
- `8444` → Nginx HTTPS (evita conflicto con Herd:443)
- `3307` → MySQL (evita conflicto con Herd:3306)
- `10050` → Zabbix Agent

## 🛠️ Comandos Útiles

### Gestión del Stack
```bash
# Iniciar servicios
docker-compose up -d

# Ver logs en tiempo real
docker-compose logs -f

# Detener servicios
docker-compose down

# Reconstruir desde cero
docker-compose down && docker-compose up --build

# Acceder al container
docker exec -it lemp-zabbix-test bash
```

### Gestión de Servicios (dentro del container)
```bash
# Estado de servicios
docker exec lemp-zabbix-test service nginx status
docker exec lemp-zabbix-test service php8.3-fpm status
docker exec lemp-zabbix-test service mysql status
docker exec lemp-zabbix-test service zabbix-agent2 status

# Reiniciar servicios
docker exec lemp-zabbix-test service nginx restart
docker exec lemp-zabbix-test service mysql restart
docker exec lemp-zabbix-test service zabbix-agent2 restart
```

### Depuración
```bash
# Ver logs de servicios
docker exec lemp-zabbix-test tail -f /var/log/nginx/error.log
docker exec lemp-zabbix-test tail -f /var/log/zabbix/zabbix_agent2.log

# Probar configuración Zabbix
docker exec lemp-zabbix-test zabbix_agent2 -t

# Conectar a MySQL
docker exec lemp-zabbix-test mysql -u testuser -ptestpass testdb
```

## 📁 Estructura del Proyecto

```
/
├── docker-compose.yml          # Orquestación principal
├── Dockerfile                  # Imagen LEMP stack
├── nginx/default.conf          # Configuración Nginx
├── zabbix/zabbix_agent2.conf  # Configuración Zabbix
├── scripts/init.sh            # Script de inicialización
├── www/                       # Archivos web
│   ├── index.php             # Dashboard principal
│   ├── test-mysql.php        # Test MySQL detallado
│   └── phpinfo.php           # Información PHP
├── logs/                      # Logs aplicación
└── mysql/data/               # Datos MySQL persistentes
```

## 🔧 Configuración

### MySQL
- **Root**: `root` / `root123`
- **Usuario**: `testuser` / `testpass`
- **Base de datos**: `testdb`

### Zabbix Agent2
- **Server**: `host.docker.internal` (tu Mac)
- **Puerto**: `10051` (servidor) / `10050` (agente)
- **Hostname**: `lemp-test-host`

## 🌐 Páginas de Prueba

- **Dashboard principal**: http://localhost:8081
- **Test MySQL**: http://localhost:8081/test-mysql.php
- **PHP Info**: http://localhost:8081/phpinfo.php

## 🔍 Troubleshooting

### Container no inicia
```bash
# Ver logs detallados
docker-compose logs

# Verificar puertos en uso
lsof -i :8081
```

### MySQL no conecta
```bash
# Verificar estado
docker exec lemp-zabbix-test service mysql status

# Reinicializar datos (CUIDADO: borra datos)
docker-compose down
rm -rf mysql/data/*
docker-compose up --build
```

### Zabbix Agent no funciona
```bash
# Verificar configuración
docker exec lemp-zabbix-test zabbix_agent2 -t

# Ver logs
docker exec lemp-zabbix-test tail -f /var/log/zabbix/zabbix_agent2.log
```

### Errores de permisos
```bash
# Reiniciar con permisos limpios
docker-compose down
docker system prune -f
docker-compose up --build
```

## 🎯 Propósito

Este entorno está diseñado para:
- Pruebas de desarrollo LEMP
- Testing de configuraciones Zabbix
- Desarrollo de aplicaciones PHP
- Monitoreo y métricas de aplicaciones

**Nota**: Este es un entorno de desarrollo/testing, no para producción.

## 🤝 Contribuir

Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 🐛 Reportar Issues

Si encuentras un bug o tienes una sugerencia:

1. Verifica que no exista un issue similar
2. Abre un nuevo issue con descripción detallada
3. Incluye pasos para reproducir el problema
4. Adjunta logs relevantes si es posible

## 📝 Notas Técnicas

- **Arquitectura**: Servicios nativos de Ubuntu systemd (sin supervisor)
- **Persistencia**: Datos MySQL en `./mysql/data/`
- **Networking**: Host networking para compatibilidad con Zabbix server
- **Configuración**: Optimizada para desarrollo y testing
- **Compatibilidad**: Diseñado para macOS con Laravel Herd

## 📋 Roadmap

- [ ] Soporte para HTTPS con certificados auto-firmados
- [ ] Configuración Zabbix server opcional incluida
- [ ] Scripts de backup/restore para MySQL
- [ ] Monitoreo adicional con Prometheus
- [ ] Docker multi-stage builds para optimización

## 📄 Licencia

Este proyecto está bajo la Licencia GNU General Public License v3.0. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

Desarrollado con ❤️ para la comunidad de desarrollo PHP y DevOps.

---

⭐ **Si este proyecto te fue útil, dale una estrella!** ⭐