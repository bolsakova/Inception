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
