# NGINX Dockerfile
# Builds a custom NGINX image from Debian.
# NGINX is the only public entry point of the infrastructure.

FROM debian:12

LABEL service="nginx"
LABEL project="inception"

ENV DEBIAN_FRONTEND=noninteractive

# Install NGINX and OpenSSL.
# OpenSSL is used to generate a self-signed TLS certificate.
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		nginx \
		openssl && \
	rm -rf /var/lib/apt/lists/*

# Copy custom NGINX configuration.
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Copy startup script.
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

# NGINX listens on HTTPS port 443.
EXPOSE 443

ENTRYPOINT ["/usr/local/bin/setup.sh"]
