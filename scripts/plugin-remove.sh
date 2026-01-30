#!/bin/bash
set -e

NAME="$1"

# Central plugin directory (like ASDF)
PLUGINS_DIR="$HOME/.makez/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate NAME
[ -z "$NAME" ] && echo "Error: NAME required. Usage: makez plugin-remove NAME=<plugin-name>" && exit 1

# Check if plugin exists
grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null || { echo "Error: Plugin not installed"; exit 1; }

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

# Confirm deletion
read -p "Remove $NAME? (y/N): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && echo "Cancelled" && exit 0

# Remove plugin directory and registry entry
[ -d "$PLUGIN_PATH" ] && rm -rf "$PLUGIN_PATH"
grep -v "^${NAME}|" "$REGISTRY" > "$REGISTRY.tmp" && mv "$REGISTRY.tmp" "$REGISTRY"

echo "Removed successfully"
