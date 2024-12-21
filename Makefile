DN = docker network
DC = docker compose
NETWORK_NAME=traefik

check_network = $(shell docker network ls --filter name=$(NETWORK_NAME) | grep -c $(NETWORK_NAME))

network: ## Create traefik network if needed
ifeq ($(check_network),)
	@$(DN) create $(NETWORK_NAME)
endif

build: ## Builds the Docker images
	@$(DC) build

build-no-cache: ## Pull images, don't use cache and build the Docker image
	@$(DC) build --no-cache

up: ## Start the docker hub
	@$(DC) up -d

up-renew-anon-volumes: ## Start the docker hub
	@$(DC) up --force-recreate --remove-orphans --renew-anon-volumes

stop: ## Stop containers
	@$(DC) stop

start: network build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DC) down --remove-orphans

logs: ## Show live logs
	@$(DC) logs --tail=0 --follow

open: ## Open
	xdg-open http://localhost:8080/dashboard
