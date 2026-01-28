# Example commands - delete or modify as needed
.PHONY: hello hello-script separator

hello: ## Say hello (inline)
	@echo "Hello from MakeZ!"

hello-script: ## Say hello (using script)
	@$(SCRIPTS_DIR)example.sh

separator: ## Print visual separator line (use: makez separator CHAR=character)
	@CHAR=$${CHAR:-=}; for i in {1..50}; do echo -n "$$CHAR"; done; echo
