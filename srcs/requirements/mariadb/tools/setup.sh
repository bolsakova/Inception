#!/bin/bash

# ***************************************************************
# 
# Initializes MariaDB on the first container start.
# Then starts mysqld as the main foreground process.
#
# ***************************************************************

# Stop the script immediately if any command fails
set -e


# 1. Read passwords from Docker secrets
# Docker mounts secrets as files inside /run/secrets.
# This keeps passwords out of Dockerfiles and Git.

DB_PASSWORD="$(cat /run/secrets/db_password)"
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"

# 2. Initialize MAriaDB only on the first run
# /var/lib/mysql/mysql contains MariaDB system tables.
# If this directory exists, the database was already initialized in the volume.

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."

	# Create MariaDB system tables inside the persistent volume.
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# 3. Start temporary MariaDB server
	# We need a temporary server to execute SQL setup commands.
	# It runs in the background only during initialization.
	mysqld_safe --datadir=/var/lib/mysql &
	pid="$!"

	echo "Waiting for MariaDB to start..."

	# 4. Wait until MariaDB is ready
	# Without this loop, SQL commands may run before MariaDB is ready.
	until mariadb-admin ping --silent; do
		sleep 1
	done

	# 5. Create database, user and permissions
	# Root password is set.
	# WordPress database and user are created.
	# The WordPress user gets access only to the WordPress database.
	mariadb -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
	# 6. Stop temporary server
	# Temporary server is stopped because the final mysqld process
	# must become the main container process.
	mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown
	wait "$pid"
fi

# 7. Start MariaDB as the main process
echo "Starting MariaDB..."

# exec replaces the shell with mysqld.
# This makes mysqld PID 1, so it receives Docker stop signals correctly.
# bind-address=0.0.0.0 allows WordPress from another container to connect.
exec mysqld --user=mysql --bind-address=0.0.0.0
