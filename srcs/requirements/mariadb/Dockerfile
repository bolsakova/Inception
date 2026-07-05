# MariaDB Dockerfile
# Builds a custom MariaDB image from Debian
# No passwords are stored here.

# Use Debian as the base image.
# Ready-made MariaDB images are forbidden by the subject.
FROM debian:12

# Metadata only. It doesn't affect runtime behavior.
LABEL service="mariadb"
LABEL project="inception"

# Prevent apt from asking interactive questions during image build.
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB server and client.
# --no-install-recommends avoids unnecessary packages.
# Cleaning /var/lib/apt/lists reduces final image size.
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		mariadb-server \
		mariadb-client && \
	rm -rf /var/lib/apt/lists/*

# Copy the startup script into the image.
COPY tools/setup.sh /usr/local/bin/setup.sh

# Make the startup script executable.
RUN chmod +x /usr/local/bin/setup.sh

# Document that MariaDB listens on port 3306.
# This does not expose the port to the host.
EXPOSE 3306

# Run the setup script when the container starts.
ENTRYPOINT ["/usr/local/bin/setup.sh"]
