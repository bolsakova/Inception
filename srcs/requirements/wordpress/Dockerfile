# WordPress Dockerfile
# Builds a custom WordPress + php-fpm image from Debian.
# No NGINX and no database are installed here.

FROM debian:12

LABEL service="wordpress"
LABEL project="inception"

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP-FPM, PHP extensions required by WordPress,
# curl for downloading wp-cli, and mariadb-client to test DB connection.
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		php-fpm \
		php-mysql \
		php-curl \
		php-gd \
		php-mbstring \
		php-xml \
		php-zip \
		curl \
		mariadb-client \
		ca-certificates && \
	rm -rf /var/lib/apt/lists/*

# Download WordPress CLI.
# wp-cli allows us to install and configure WordPress from a script.
RUN curl -o /usr/local/bin/wp \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Copy the WordPress startup script.
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

# php-fpm listens on port 9000 inside the Docker network.
# This port is not exposed to the host machine.
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
