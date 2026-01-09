# Plugin management commands
.PHONY: plugin-install plugin-list plugin-remove plugin-update plugin-info

plugin-install: ## Install plugin (usage: makez plugin-install URL=<url> [NAME=<name>])
	@$(SCRIPTS_DIR)plugin-install.sh "$(URL)" "$(NAME)"

plugin-list: ## List all installed plugins
	@$(SCRIPTS_DIR)plugin-list.sh

plugin-remove: ## Remove plugin (usage: makez plugin-remove NAME=<name>)
	@$(SCRIPTS_DIR)plugin-remove.sh "$(NAME)"

plugin-update: ## Update plugin (usage: makez plugin-update NAME=<name>)
	@$(SCRIPTS_DIR)plugin-update.sh "$(NAME)"

plugin-info: ## Show plugin details (usage: makez plugin-info NAME=<name>)
	@$(SCRIPTS_DIR)plugin-info.sh "$(NAME)"
