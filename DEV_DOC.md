# Developer Documentation

## Project Structure

```text
	inception/
	|
	|--- Makefile
	|--- README.md
	|--- USER_DOC.md
	|--- DEV_DOC.md
	|--- secrets/
	|--- srcs/
	|	 |--- .env
	|	 |--- docker-compose.yml
	|	 |--- requirements/
	|		  |--- mariadb/
	|		  |--- nginx/
	|		  |--- wordpress/
```

---

## Infrastructure

The project consists of three independent Docker containers.

### NGINX

Responsibilities:

- HTTPS termination
- TLS certificate
- Reverse proxy
- Static file serving
- FastCGI forwarding

NGINX exposes only port `443`.

### WordPress

Responsibilities:

- Execute PHP through PHP-FPM
- configure WordPress
- Connect to MariaDB
- Create administrator and regular user

PHP-FPM listens internally on port `9000`.

### MariaDB

Responsibilities:

- Store all WordPress data
- Create database
- Create database user
- Manage persistent storage

MariaDB listens internally on port `3306`.

---

## Docker Network

All containers communicate through a dedicated Docker bridge network.

Docker automatically provides internal DNS resolution, allowing services to communicate using their service names:

- nginx
- wordpress
- mariadb

---

## Persistent Storage

Persistent Docker volumes are used for:

- MariaDB database
- WordPress files

The volumes are stored on the host machine inside:

```text
	/home/<login>/data
```

---

## Environment Variables

Non-sensitive configuration values are stored inside:

```text
	srcs/.env
```

Examples:

- domain name
- database name
- usernames
- website title

---

## Docker Secrets

Sensitive information is stored separately using Docker Secrets.

Examples:

- database password
- root password
- WordPress administrator password

Secrets are mounted inside containers under:

```text
	/run/secrets
```

---

## Build Process

The project is built using:

```bash
	make
```

Internally this executes:

```bash
	docker compose \
	-f srcs/docker-compose.yml \
	--env-file srcs/.env \
	up -d --build

```

---

## Useful commands

Show container status:

```bash
	make ps
```

Show logs:

```bash
	make logs
```

Stop project:

```bash
	make down
```

Rebuild project:

```bash
	make re
```

## Troubleshooting

### Containers are restarting

Check logs:

```bash
	make logs
```

### MariaDB connection failed

Verify:

- MariaDB container is running
- Database credentials are correct
- Docker network is available

### HTTPS does not work

Verify:

- NGINX container is running
- Port `443` is available
- `/etc/hosts` contains the correct domain.
- The TLS certificate was generated successfully.

## Notes

Each service is built from its own Dockerfile.

The project follows the mandatory requirements of the 42 Inception subject:

- custom Docker images
- dedicated Docker network
- Docker named volumes
- HTTPS only
- one process per container
- no pre-built service images
- no host networking
