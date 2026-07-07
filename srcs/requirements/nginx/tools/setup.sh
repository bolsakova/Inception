#!/bin/bash

# NGINX setup script
# Generates a self-signed TLS certificate if it doesn't exist.
# Then starts NGINX as the main foreground process.

set -e

SSL_DIR="/etc/nginx/ssl"
SSL_KEY="${SSL_DIR}/inception.key"
SSL_CRT="${SSL_DIR}/inception.crt"

# 1. Create SSL directory
mkdir -p "${SSL_DIR}"

# 2. Generate self-signed certificate if missing
if [ ! -f "${SSL_KEY}" ] || [ ! -f "${SSL_CRT}" ]; then
	echo "Generating self-signed TLS certificate..."

	openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "${SSL_KEY}" \
        -out "${SSL_CRT}" \
        -subj "/C=DE/ST=Baden-Wuerttemberg/L=Heilbronn/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

# 3. Start NGINX
echo "Starting NGINX..."

# daemon off keeps NGINX in the foreground
# exec makes nginx PID 1 inside the container
exec nginx -g "daemon off;"
