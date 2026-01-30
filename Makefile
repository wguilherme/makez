# MakeZ - Global Makefiles Toolkit
# Clone, customize, and run your commands from anywhere

SHELL := /bin/bash

# Get makefile directory for includes (must be BEFORE any includes)
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Load .env if exists
-include .env

# Shortcut for scripts folder
SCRIPTS_DIR := $(MAKEFILE_DIR)scripts/

# Auto-include all .mk files from makefiles/
include $(wildcard $(MAKEFILE_DIR)makefiles/*.mk)

# Auto-include all plugin.mk files from central directory
include $(wildcard ~/.makez/plugins/*/plugin.mk)

.DEFAULT_GOAL := help

.PHONY: help version

help: ## Show available commands
	@echo ""
	@echo "  MakeZ - Your automation toolbox"
	@echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-18s %s\n", $$1, $$2}'
	@echo ""
	@echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Usage: makez <command>"
	@echo "  Add your own commands in makefiles/*.mk"
	@echo ""

version: ## Show version
	@echo "MakeZ v1.0.0"
