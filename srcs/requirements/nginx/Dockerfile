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

# Create directory for TLS certificate and key.
RUN mkdir -p /etx/nginx/ssl

# Generate a self-signed certificate for local HTTPS.
# This is acceptable for a local 42 project
RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=42/OU=Inception/CN=tbolsako.42.fr"

# NGINX listens on HTTPS port 443.
EXPOSE 443

# Start NGINX in the foreground.
# daemon off is required so the container keeps running.
CMD ["nginx", "-g", "daemon off;"]
