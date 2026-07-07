*This project has been created as part of the 42 curriculum by tbolsako.*

# Inception

## Description

Inception is a system administration project based on Docker.

The goal is to build a small infrastructure composed of three services:

- NGINX with TLS
- WordPress with php-fpm
- MariaDB

Each service runs in its own Docker container and is built from a custom Dockerfile.

NGINX is the only public entry point. It exposes only port `443` and forward PHP requests to the WordPress container.

WordPress communicates with MariaDB through a dedicated Docker network.

Persistent data is stored in Docker named volumes:

- `wordpress_data`
- `mariadb_data`

The data is stored on the host machine in - `/home/tbolsako/data`

---

## Architecture

The infrastructure consists of three independent services, each running inside its own Docker container.

- **NGINX** acts as the only public entry point. It accepts HTTPS connections on port `443`, terminates the TLS connection, and forwards PHP requests to the WordPress container.
- **WordPress** runs together with **php-fpm**. It processes PHP code and communicates with the MariaDB database.
- **MariaDB** stores all persistent WordPress data, including users, posts, pages, comments and configuration.

Thr communication flow is

```text
	Browser
		|
	HTTPS :443
		|
		▼
	NGINX
		|
	FastCGI :9000
		|
		▼
	WordPress + php-fpm
		|
	SQL :3306
		|
		▼
	MariaDB
```

The services communicate through a dedicated Docker bridge network and store persistent data inside Docker named volumes.

---

## Features

- Custom Docker images built from Debian
- NGINX configured with TLS 1.2 / TLS 1.3
- WordPress running with php-fpm
- MariaDB database
- Docker named volumes for persistent storage
- Dedicated Docker bridge network
- Docker Secrets for sensitive credentials
- Automatic initialization scripts

---

## Instructions

1. Build and start the infrastructure:

```bash
	make
```

2. Stop all running containers:

```bash
	make down
```

3. Remove containers, networks and Docker volumes:

```bash
	make clean
```

4. Completely remove the project, including local persistent data:

```bash
	make fclean
```

5. Rebuild the entire infrastructure from scratch:

```bash
	make re
```

---

## Project Design Choices

### Virtual Machines vs Docker

A virtual machine emulates an entire operating system with its own kernel. This approach provides strong isolation but requires significantly more memory and storage.

Docker containers, on the other hand, share the host Linux kernel while isolating processes, file systems and networks. As a result, containers start much faster and consume considerably fewer resources.

### Secrets vs Environment Variables

Environment variables are used for non-sensitive configuration such as domain names or usernames.

Passwords are stored separately using Docker Secrets, allowing containers to read sensitive information from mounted files instead of embedding credentials directly into Dockerfiles or configuration files.

### Docker Network vs Host Network

The project uses a dedicated Docker bridge network.

This allows the containers to communicate using Docker's built-in DNS while remaining isolated from the host network. The `host` network node is intentionally avoided because it removes this isolation and is forbidden by the project requirements.

### Docker Volumes vs Bind Mounts

Docker named volumes are used to provide persistent storage for both the WordPress files and the MariaDB database.

Unlike bind mounts, Docker volumes are managed by Docker itself, making them easier to migrate, safer to use and better suited for long-term persistent application data.

---

## Technologies

- Docker
- Docker Compose
- Debian 12
- NGINX
- WordPress
- PHP-FPM
- MariaDB
- OpenSSL

---

## Resources

The following resources were used during the development of tis project:

- Docker Documentation
- Docker Compose Documentation
- NGINX Documentation
- MariaDB Documentation
- WordPress CLI Documentation
- PHP-FPM Documentation

---

## AI Usage

AI was used for:
- explaining Docker concepts
- reviewing configuration files
- clarifying system administration topics
- improving documentation (structure and language)
