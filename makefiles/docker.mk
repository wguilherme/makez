# Docker utilities
.PHONY: docker-clean docker-ps docker-stop-all docker-prune docker-stats

docker-ps: ## List running containers with stats
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

docker-stop-all: ## Stop all running containers
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); \
		echo "✅ All containers stopped"; \
	else \
		echo "No running containers"; \
	fi

docker-clean: ## Remove stopped containers and dangling images
	@$(SCRIPTS_DIR)docker-clean.sh

docker-prune: ## Full cleanup (containers, images, volumes, networks)
	@docker system prune -af --volumes
	@echo "✅ Docker pruned"

docker-stats: ## Show resource usage of running containers
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
