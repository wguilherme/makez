#!/bin/bash

NAME="$1"

# Central plugin directory (like ASDF)
PLUGINS_DIR="$HOME/.makez/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate NAME
[ -z "$NAME" ] && echo "Error: NAME required. Usage: makez plugin-info NAME=<plugin-name>" && exit 1

# Check if plugin exists
grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null || { echo "Error: Plugin not installed"; exit 1; }

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

# Get plugin info from registry
INFO=$(grep "^${NAME}|" "$REGISTRY")
IFS='|' read -r _ url date commit <<< "$INFO"

echo "$NAME"
echo "  URL: $url"
echo "  Installed: $date | Commit: $commit"
echo "  Path: $PLUGIN_PATH"
echo ""

# Show available commands
echo "Commands:"
PLUGIN_MK="$PLUGIN_PATH/plugin.mk"
[ -f "$PLUGIN_MK" ] && grep -E "^[a-zA-Z_-]+:.*?## " "$PLUGIN_MK" | sed 's/:.*##/  -/' || echo "  (none found)"
echo ""

# Show recent commits
echo "Recent commits:"
cd "$PLUGIN_PATH"
git log --oneline --no-decorate -5 | sed 's/^/  /'
