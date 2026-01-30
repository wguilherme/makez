# 📦 MakeZ

> A modular toolkit for creating your own global Make commands

MakeZ is a **boilerplate/framework** for building your personal automation toolbox. Clone it, add your own commands, and run them from anywhere.

The included modules are **examples** to get you started.

## 🚀 Install

```bash
# Clone the repository
git clone https://github.com/wguilherme/makez.git ~/makez

# Add alias to your shell
echo "alias makez='make -f ~/makez/Makefile'" >> ~/.zshrc
source ~/.zshrc

# Test it
makez help
```

## 🔧 Create Your First Command

Create `makefiles/my-commands.mk`:

```makefile
.PHONY: greet greet-script

greet: ## Say hello (inline)
	@echo "Hello from MakeZ!"

greet-script: ## Say hello (using script)
	@$(SCRIPTS_DIR)greet.sh
```

Create `scripts/greet.sh`:

```bash
#!/bin/bash
echo "Hello from MakeZ script!"
```

Run from anywhere:

```bash
makez greet
makez greet-script
```

## 📁 Structure

```
makez/
├── Makefile              # Main file (auto-includes all .mk modules)
├── makefiles/            # Your command modules
│   ├── docker.mk         # Docker utilities
│   └── example.mk        # Simple example
└── scripts/              # Helper shell scripts
```

## 📐 Naming Convention

Use `module-command` pattern to group related commands in help output:

```makefile
# makefiles/docker.mk
docker-ps: ## List containers
docker-clean: ## Remove stopped containers
docker-prune: ## Full cleanup
```

Since `makez help` sorts alphabetically, prefixed commands stay grouped:

```bash
docker-clean       Remove stopped containers
docker-prune       Full cleanup
docker-ps          List containers
```

See `makefiles/docker.mk` for a real example.

## 🔌 Plugins

Install command modules from remote repositories, similar to ASDF's plugin system. Plugins are stored in `~/.makez/plugins/` and auto-loaded from anywhere:

```bash
# Install a plugin
makez plugin-install URL=https://github.com/user/makez-plugin.git

# List installed plugins
makez plugin-list

# Get plugin details
makez plugin-info NAME=plugin-name

# Update a plugin
makez plugin-update NAME=plugin-name

# Remove a plugin
makez plugin-remove NAME=plugin-name
```

**Create your own plugin:**

Use the [official template](https://github.com/wguilherme/makez-plugin-template) or create a git repository with a `plugin.mk` file:

```makefile
.PHONY: myplugin-hello

myplugin-hello: ## Say hello from plugin
    @echo "Hello from my plugin!"
```

Plugins are auto-loaded and appear in `makez help`. Perfect for sharing command sets across teams.

## 💡 Tips

- **Use `## description`** after targets for auto-generated help
- **One module per category**: `makefiles/docker.mk`, `makefiles/git.mk`
- **Scripts folder**: Put complex logic in `scripts/` and call from `.mk`

## 📝 License

MIT - Use it, fork it, make it yours.
