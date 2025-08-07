# Makefile for Jenkins + Ansible with Named Container Support

.DEFAULT_GOAL := help

COMPOSE = docker-compose
JENKINS = jenkins-builder
ANSIBLE = ansible-runner

.PHONY: up down restart start stop ansible ansible-bash jenkins-bash jenkins-logs ansible-logs status help

up: ## Start all services (jenkins + ansible)
	@$(COMPOSE) up -d --build

down: ## Stop all services
	@$(COMPOSE) down

restart: down up ## Restart all services

start: ## Start a specific service (use like: make start service=jenkins)
ifndef service
	$(error Please specify the service name. Usage: make start service=jenkins)
endif
	@$(COMPOSE) up -d --build $(service)

stop: ## Stop a specific service (use like: make stop service=ansible)
ifndef service
	$(error Please specify the service name. Usage: make stop service=ansible)
endif
	@$(COMPOSE) stop $(service)

remove: ## Remove a specific service (use like: make remove service=jenkins)
ifndef service
	$(error Please specify the service name. Usage: make remove service=jenkins)
endif
	@$(COMPOSE) rm $(service)

remove_all: ## Remove all services
	@$(COMPOSE) rm $(JENKINS) $(ANSIBLE)

ansible: ## Run Ansible playbook
	@docker exec -it $(ANSIBLE) ansible-playbook -i inventory playbook.yml

ansible-bash: ## Shell into ansible container
	@docker exec -it $(ANSIBLE) sh

jenkins-bash: ## Shell into jenkins container
	@docker exec -it $(JENKINS) bash

jenkins-logs: ## Tail logs from Jenkins container
	@docker logs -f $(JENKINS)

ansible-logs: ## Tail logs from Ansible container
	@docker logs -f $(ANSIBLE)

status: ## Show status of running containers
	@$(COMPOSE) ps


status_all: ## Show status of all containers
	@$(COMPOSE) ps -a


help: ## Show this help message
	@echo "\033[1;33mUsage:\033[0m make <target> \n"
	@echo "\033[1;33mAvailable targets:\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " \033[36m%-15s\033[0m %s\n", $$1, $$2}'
