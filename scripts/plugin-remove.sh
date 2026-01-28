#!/bin/bash
set -e

NAME="$1"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAKEZ_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$MAKEZ_DIR/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate NAME
if [ -z "$NAME" ]; then
    echo "Error: NAME is required"
    echo "Usage: makez plugin-remove NAME=<plugin-name>"
    echo ""
    echo "Run 'makez plugin-list' to see installed plugins"
    exit 1
fi

# Check if plugin exists
if ! grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null; then
    echo "Plugin '$NAME' is not installed"
    echo ""
    echo "Run 'makez plugin-list' to see installed plugins"
    exit 1
fi

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

# Show what will be removed
echo "Removing plugin '$NAME'..."
echo ""

# Get plugin info
INFO=$(grep "^${NAME}|" "$REGISTRY")
IFS='|' read -r _ url _ _ <<< "$INFO"
echo "URL: $url"
echo "Path: $PLUGIN_PATH"
echo ""

# Confirm deletion
read -p "Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Remove plugin directory
if [ -d "$PLUGIN_PATH" ]; then
    rm -rf "$PLUGIN_PATH"
fi

# Remove from registry
grep -v "^${NAME}|" "$REGISTRY" > "$REGISTRY.tmp"
mv "$REGISTRY.tmp" "$REGISTRY"

echo "Plugin '$NAME' removed successfully!"
