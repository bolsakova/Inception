#!/bin/bash

# Downloads and configures WordPress on the first container start.
# Then starts php-fpm as the main foreground process.

set -e


# 1. Read passwords from Docker secrets
# Database password used by the WordPress database user.
DB_PASSWORD="$(cat /run/secrets/db_password)"

# WordPress administrator password.
WP_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"

# 2. Wait for MariaDB
echo "Waiting for MariaDB..."

# depends_on only starts the MariaDB container.
# This loop waits until the database is really ready to accept connections.
until mariadb \
    -h mariadb \
    -u "${MYSQL_USER}" \
    -p"${DB_PASSWORD}" \
    "${MYSQL_DATABASE}" \
    -e "SELECT 1;" > /dev/null 2>&1; do
    sleep 1
done

echo "MariaDB is ready."

# 3. Install WordPress only on the first run
cd /var/www/html

# wp-config.php is created during WordPress installation.
# If it already exists, WordPress was already configured in the volume.
if [ ! -f "wp-config.php" ]; then
	echo "Downloading WordPress..."

	# Download WordPress core files into /var/www/html.
    wp core download \
        --allow-root

    echo "Creating wp-config.php..."

	# Create WordPress configuration file.
    # DB_HOST is the MariaDB service name inside the Docker network.
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    echo "Installing WordPress..."

	# Install WordPress and create the administrator account.
    # Important: WP_ADMIN_USER must not contain "admin" or "administrator".
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Creating regular WordPress user..."

	# Create a second non-admin WordPress user.
    # The subject requires two users, one of them being the administrator.
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${DB_PASSWORD}" \
        --allow-root
fi

# 4. Start php-fpm as the main process
echo "Starting php-fpm..."

# Create runtime directory required by php-fpm.
mkdir -p /run/php

# exec replaces the shell with php-fpm.
# -F keeps php-fpm in the foreground, which is required for Docker containers.
exec php-fpm* -F
