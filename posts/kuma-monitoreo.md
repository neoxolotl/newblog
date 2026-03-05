# Uptime Kuma - Sistema de Monitoreo con Docker

**Versión:** 1.0
**Actualización:** Marzo 2026
**Autor:** neoxolotl

---

# Índice

1. Introducción
2. Arquitectura
3. Requisitos
4. Instalación con Docker
5. Docker Compose
6. Primer Acceso y Configuración
7. Creación de Monitores
8. Notificaciones y Alertas
9. Dashboards y Estado Público
10. Mantenimiento
11. Solución de Problemas
12. Recursos

---

# 1. Introducción

**Uptime Kuma** es una herramienta de monitoreo **open source** que permite supervisar servicios, servidores y aplicaciones mediante verificaciones periódicas.

Es una alternativa moderna y ligera a herramientas como:

* Nagios
* Zabbix
* UptimeRobot

Uptime Kuma puede ejecutarse fácilmente utilizando **Docker**, lo que simplifica su instalación y mantenimiento.

---

## Características

* Monitoreo HTTP / HTTPS
* Ping ICMP
* TCP Port
* DNS
* Monitoreo de Docker
* Notificaciones en múltiples plataformas
* Dashboard web
* Estado público para servicios

---

## Ventajas

* Open source
* Interfaz web moderna
* Fácil instalación con Docker
* Consumo bajo de recursos
* Integración con múltiples sistemas de alerta

---

## Casos de uso

* Monitoreo de sitios web
* Supervisión de APIs
* Monitoreo de servidores
* Estado de servicios públicos

---

# 2. Arquitectura

## Flujo de monitoreo

```id="8xj10o"
Servicios / Infraestructura
        ↓
   Uptime Kuma
        ↓
Motor de chequeos
        ↓
Base de datos SQLite
        ↓
Dashboard Web
        ↓
Alertas y Notificaciones
```

---

## Componentes

* **Servidor Kuma**
* **Motor de monitoreo**
* **Base de datos SQLite**
* **Interfaz web**
* **Sistema de notificaciones**

---

## Vista conceptual

```id="9xj3fz"
           ┌─────────────┐
           │  Usuario    │
           └──────┬──────┘
                  │
                  ▼
           ┌─────────────┐
           │  Dashboard  │
           │ Uptime Kuma │
           └──────┬──────┘
                  │
      ┌───────────┼───────────┐
      ▼           ▼           ▼
   HTTP Check   Ping       TCP Check
      │           │           │
      ▼           ▼           ▼
   Servicios   Servidores   APIs
```

---

# 3. Requisitos

## Hardware recomendado

* CPU: 1 núcleo
* RAM: 512 MB
* Disco: 1 GB

---

## Software necesario

* Docker
* Docker Compose

Instalar Docker en Ubuntu:

```bash id="7k43bh"
sudo apt update
sudo apt install docker.io docker-compose
```

---

## Verificar instalación

```bash id="8f7d0x"
docker --version
docker compose version
```

---

# 4. Instalación con Docker

Crear un directorio para el servicio:

```bash id="k3j3z9"
mkdir uptime-kuma
cd uptime-kuma
```

---

Crear carpeta de persistencia:

```bash id="lm49r2"
mkdir data
```

---

# 5. Docker Compose

Crear el archivo:

```bash id="j21kx0"
nano docker-compose.yml
```

---

Contenido del archivo:

```yaml id="t4x9q3"
version: "3"

services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    restart: always
    ports:
      - "3001:3001"
    volumes:
      - ./data:/app/data
```

---

Iniciar el servicio:

```bash id="12q8ze"
docker compose up -d
```

---

Ver contenedores activos:

```bash id="d2n7y1"
docker ps
```

---

# 6. Primer Acceso y Configuración

Abrir navegador y acceder a:

```id="9n87ac"
http://IP_SERVIDOR:3001
```

---

## Configuración inicial

1. Crear usuario administrador
2. Definir contraseña
3. Acceder al dashboard principal

---

## Vista general del sistema

```id="m6p6sh"
Dashboard
   │
   ├── Monitores
   ├── Notificaciones
   ├── Estado público
   └── Configuración
```

---

# 7. Creación de Monitores

Para monitorear un servicio:

1. Click en **Add New Monitor**
2. Seleccionar tipo de monitor
3. Definir dirección del servicio
4. Configurar intervalo de chequeo

---

## Tipos de monitores

| Tipo   | Uso                                    |
| ------ | -------------------------------------- |
| HTTP   | Monitorear páginas web                 |
| Ping   | Verificar disponibilidad de servidores |
| TCP    | Monitorear puertos                     |
| DNS    | Validar resolución DNS                 |
| Docker | Estado de contenedores                 |

---

## Ejemplo de monitor HTTP

```id="j4nt8p"
Nombre: Web Server
Tipo: HTTP
URL: https://miweb.com
Intervalo: 60 segundos
```

---

# 8. Notificaciones y Alertas

Uptime Kuma soporta múltiples integraciones de notificación.

---

## Sistemas soportados

* Email SMTP
* Telegram
* Discord
* Slack
* Webhooks
* Pushover
* Gotify

---

## Ejemplo configuración Telegram

1. Crear bot con **BotFather**
2. Obtener **API Token**
3. Agregar en notificaciones

---

## Flujo de alertas

```id="pxu1u6"
Monitor falla
     ↓
Evento detectado
     ↓
Sistema de alertas
     ↓
Notificación enviada
```

---

# 9. Dashboards y Estado Público

Uptime Kuma permite crear **páginas públicas de estado**.

---

## Ejemplo de uso

Mostrar estado de servicios como:

* API
* Sitio web
* Base de datos
* Servicios internos

---

## Flujo del estado público

```id="d1fw99"
Usuarios
   ↓
Página de estado
   ↓
Información de monitores
   ↓
Estado actual del servicio
```

---

## Ejemplo de estado

```id="n7ru6o"
API Server        ✔ Online
Web Frontend      ✔ Online
Database          ✔ Online
Auth Service      ✖ Offline
```

---

# 10. Mantenimiento

Actualizar contenedor:

```bash id="g64tnv"
docker compose pull
docker compose up -d
```

---

Ver logs del sistema:

```bash id="9u8ib1"
docker logs uptime-kuma
```

---

Realizar backup:

```bash id="f37s7o"
tar -czvf backup-kuma.tar.gz data/
```

---

# 11. Solución de Problemas

## El contenedor no inicia

Ver logs:

```bash id="7z9cde"
docker logs uptime-kuma
```

---

## Puerto ocupado

Verificar puertos:

```bash id="n8pj90"
sudo netstat -tulpn
```

---

## Problemas de permisos

Corregir permisos:

```bash id="2jpt91"
sudo chown -R 1000:1000 data
```

---

## Reiniciar servicio

```bash id="yt1rb6"
docker compose restart
```

---

# 12. Recursos

## Documentación Oficial

Uptime Kuma
https://github.com/louislam/uptime-kuma

Docker
https://docs.docker.com

Docker Compose
https://docs.docker.com/compose

---

# Licencia

**Licencia MIT**

Última revisión: **Marzo 2026**
Mantenido por: **neoxolotl**
Versión: **1.0**
