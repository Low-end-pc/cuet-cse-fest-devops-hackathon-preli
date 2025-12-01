# Docker Services:
#   up - Start services (use: make up [service...] or make up MODE=prod, ARGS="--build" for options)
#   down - Stop services (use: make down [service...] or make down MODE=prod, ARGS="--volumes" for options)
#   build - Build containers (use: make build [service...] or make build MODE=prod)
#   logs - View logs (use: make logs [service] or make logs SERVICE=backend, MODE=prod for production)
#   restart - Restart services (use: make restart [service...] or make restart MODE=prod)
#   shell - Open shell in container (use: make shell [service] or make shell SERVICE=gateway, MODE=prod, default: backend)
#   ps - Show running containers (use MODE=prod for production)
#
# Convenience Aliases (Development):
#   dev-up - Alias: Start development environment
#   dev-down - Alias: Stop development environment
#   dev-build - Alias: Build development containers
#   dev-logs - Alias: View development logs
#   dev-restart - Alias: Restart development services
#   dev-shell - Alias: Open shell in backend container
#   dev-ps - Alias: Show running development containers
#   backend-shell - Alias: Open shell in backend container
#   gateway-shell - Alias: Open shell in gateway container
#   mongo-shell - Open MongoDB shell
#
# Convenience Aliases (Production):
#   prod-up - Alias: Start production environment
#   prod-down - Alias: Stop production environment
#   prod-build - Alias: Build production containers
#   prod-logs - Alias: View production logs
#   prod-restart - Alias: Restart production services
#
# Backend:
#   backend-build - Build backend TypeScript
#   backend-install - Install backend dependencies
#   backend-type-check - Type check backend code
#   backend-dev - Run backend in development mode (local, not Docker)
#
# Database:
#   db-reset - Reset MongoDB database (WARNING: deletes all data)
#   db-backup - Backup MongoDB database
#
# Cleanup:
#   clean - Remove containers and networks (both dev and prod)
#   clean-all - Remove containers, networks, volumes, and images
#   clean-volumes - Remove all volumes
#
# Utilities:
#   status - Alias for ps
#   health - Check service health
#
# Help:
#   help - Display this help message

.PHONY: up down build logs restart shell ps dev-up dev-down dev-build dev-logs dev-restart dev-shell dev-ps backend-shell gateway-shell mongo-shell prod-up prod-down prod-build prod-logs prod-restart backend-build backend-install backend-type-check backend-dev db-reset db-backup clean clean-all clean-volumes status health help

up:
	@docker-compose up $(ARGS) $(SERVICE)

down:
	@docker-compose down $(ARGS) $(SERVICE)

build:
	@docker-compose build $(SERVICE)

logs:
	@docker-compose logs $(SERVICE)

restart:
	@docker-compose restart $(SERVICE)

shell:
	@docker-compose exec $(SERVICE) bash

ps:
	@docker-compose ps

dev-up:
	@make up MODE=dev

dev-down:
	@make down MODE=dev

dev-build:
	@make build MODE=dev

dev-logs:
	@make logs MODE=dev

dev-restart:
	@make restart MODE=dev

dev-shell:
	@make shell SERVICE=backend MODE=dev

dev-ps:
	@make ps MODE=dev

backend-shell:
	@make shell SERVICE=backend

gateway-shell:
	@make shell SERVICE=gateway

mongo-shell:
	@make shell SERVICE=mongo

prod-up:
	@make up MODE=prod

prod-down:
	@make down MODE=prod

prod-build:
	@make build MODE=prod

prod-logs:
	@make logs MODE=prod

prod-restart:
	@make restart MODE=prod

backend-build:
	@docker-compose exec backend npm run build

backend-install:
	@docker-compose exec backend npm install

backend-type-check:
	@docker-compose exec backend npm run type-check

backend-dev:
	@docker-compose exec backend npm run dev

db-reset:
	@docker-compose exec mongo mongo cuet-cse-fest-devops-hackathon-preli --eval "db.dropDatabase()"

db-backup:
	@docker-compose exec mongo mongodump -d cuet-cse-fest-devops-hackathon-preli -o /backup

clean:
	@docker-compose down -v --remove-orphans
	@docker network prune -f

clean-all:
	@docker-compose down -v --remove-orphans
	@docker network prune -f
	@docker volume prune -f
	@docker image prune -f

clean-volumes:
	@docker volume prune -f

status:
	@make ps

health:
	@docker-compose ps

help:
	@echo "Makefile targets:"
	@echo "  up              Start services"
	@echo "  down            Stop services"
	@echo "  build           Build containers"
	@echo "  logs            View logs"
	@echo "  restart         Restart services"
	@echo "  shell           Open shell in container"
	@echo "  ps              Show running containers"
	@echo "  dev-up          Start development environment"
	@echo "  dev-down        Stop development environment"
	@echo "  dev-build       Build development containers"
	@echo "  dev-logs        View development logs"
	@echo "  dev-restart     Restart development services"
	@echo "  dev-shell       Open shell in backend container"
	@echo "  dev-ps          Show running development containers"
	@echo "  backend-shell   Open shell in backend container"
	@echo "  gateway-shell   Open shell in gateway container"
	@echo "  mongo-shell     Open MongoDB shell"
	@echo "  prod-up         Start production environment"
	@echo "  prod-down       Stop production environment"
	@echo "  prod-build      Build production containers"
	@echo "  prod-logs       View production logs"
	@echo "  prod-restart    Restart production services"
	@echo "  backend-build   Build backend TypeScript"
	@echo "  backend-install Install backend dependencies"
	@echo "  backend-type-check Type check backend code"
	@echo "  backend-dev     Run backend in development mode (local, not Docker)"
	@echo "  db-reset        Reset MongoDB database (WARNING: deletes all data)"
	@echo "  db-backup       Backup MongoDB database"
	@echo "  clean           Remove containers and networks (both dev and prod)"
	@echo "  clean-all       Remove containers, networks, volumes, and images"
	@echo "  clean-volumes   Remove all volumes"
	@echo "  status          Alias for ps"
	@echo "  health          Check service health"
	@echo "  help            Display this help message"
