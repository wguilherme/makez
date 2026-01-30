#!/bin/bash
set -e

URL="$1"
NAME="$2"

# Central plugin directory (like ASDF)
PLUGINS_DIR="$HOME/.makez/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Ensure plugin directory exists
mkdir -p "$PLUGINS_DIR"

# Validate URL
[ -z "$URL" ] && echo "Error: URL required. Usage: makez plugin-install URL=<git-url> [NAME=<name>]" && exit 1

# Extract plugin name from URL if not provided
[ -z "$NAME" ] && NAME=$(basename "$URL" .git)

# Validate plugin name
[[ ! "$NAME" =~ ^[a-z0-9-]+$ ]] && echo "Error: Invalid plugin name. Use lowercase alphanumeric with dashes only" && exit 1

# Check if plugin already exists
grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null && echo "Error: Plugin already installed. Use plugin-update to update" && exit 1

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

echo "Installing $NAME from $URL..."

# Clone repository
git clone --quiet "$URL" "$PLUGIN_PATH" 2>/dev/null || { echo "Error: Failed to clone repository"; exit 1; }

# Verify plugin.mk exists
[ ! -f "$PLUGIN_PATH/plugin.mk" ] && echo "Error: Missing plugin.mk file" && rm -rf "$PLUGIN_PATH" && exit 1

# Get commit hash
cd "$PLUGIN_PATH"
COMMIT_HASH=$(git rev-parse --short HEAD)
cd - > /dev/null

# Add to registry
echo "${NAME}|${URL}|$(date +%Y-%m-%d)|${COMMIT_HASH}" >> "$REGISTRY"

echo "Installed successfully. Run 'makez help' to see commands"
