# User Documentation

## Overview

This project deploys a complete WordPress infrastructure using Docker.

The infrastructure consists of:

- NGINX
- WordPress with PHP-FPM
- MariaDB

NGINX is the only public entry point and serves the website over HTTPS.

---

## Requirements

Before starting the project, make sure the following software is installed:

- Docker
- Docker Compose
- GNU Make

---

## Starting the project

From the project root directory run:

```bash
	make
```

This command will:

- create the required data directories
- build all docker images
- create the Docker network
- create persistent Docker volumes
- start all containers

---

## Stopping the project

To stop all running containers:

```bash
	make down
```

Persistent data will remain available.

---

## Rebuilding the project

To rebuild everything from scratch:

```bash
	make re
```

---

## Removing all data

To completely remove the project including persistent storage:

```bash
	make fclean
```

---

## Website

Open your browser and visit:

```text
	https://<login>.42.fr
```

If necessary, add the following entry to your `/etc/hosts` file:

```text
	127.0.0.1	<login>.42.fr
```

Replace `<login>` with your own 42 login.

---

## WordPress Administration

The administration panel is available at:

```text
	https://<login>.42.fr/wp-admin
```

The administrator username is defined inside:

```text
	srcs/.env
```

The administrator password is stored inside:

```text
	secrets/wp_admin_password.txt
```

---

## Logs

View logs from all containers;

```bash
	make logs
```

Follow logs in real time:

```bash
	make logs-follow
```

---

## Useful Docker Commands

Running containers:

```bash
	docker ps
```

Container status:

```bash
	docker compose -f  srcs/docker-compose.yml ps
```

Enter a running container:

```bash
	docker exec -it <container_name> bash
```
