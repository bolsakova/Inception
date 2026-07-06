# Path to the Docker Compose file
COMPOSE_FILE = srcs/docker-compose.yml

# Path to the environment file
ENV_FILE = srcs/.env

# Data directories required by the subject
LOGIN = tbolsako
DATA_DIR = /home/$(LOGIN)/data
WORDPRESS_DIR = $(DATA_DIR)/wordpress
MARIADB_DIR = $(DATA_DIR)/mariadb

# Default target 
all: up

# Create required host directories for Docker named volumes
# Then build and start containers in detached mode
up:
	mkdir -p $(WORDPRESS_DIR)
	mkdir -p $(MARIADB_DIR)
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

# Stop containers without deleting them
down:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down

# Stop and remove containers, networks and named volumes
# This deletes persistent WordPress and MariaDB data from Docker's point of view.
clean:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down -v

# Full cleanup
# Stop project, remove volumes, remove local data directories
fclean: clean
	sudo rm -rf $(DATA_DIR)

# Rebuild everything from scratch
re: fclean all

# Show running containers for this project
ps:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) ps

# Show logs from all services
logs:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) logs

# Show logs and keep following new output
logs-follow:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) logs -f


.PHONY: all up down clean fclean re ps logs logs-follow
