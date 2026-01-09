#!/bin/bash
set -e

URL="$1"
NAME="$2"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAKEZ_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$MAKEZ_DIR/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate URL
if [ -z "$URL" ]; then
    echo "❌ Error: URL is required"
    echo "Usage: makez plugin-install URL=<git-url> [NAME=<name>]"
    exit 1
fi

# Extract plugin name from URL if not provided
if [ -z "$NAME" ]; then
    NAME=$(basename "$URL" .git)
fi

# Validate plugin name (lowercase, no special chars except dash)
if [[ ! "$NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo "❌ Error: Invalid plugin name '$NAME'"
    echo "Plugin names must be lowercase alphanumeric with dashes only"
    exit 1
fi

# Check if plugin already exists
if grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null; then
    echo "❌ Plugin '$NAME' is already installed"
    echo "Use 'makez plugin-update NAME=$NAME' to update it"
    exit 1
fi

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

echo "📦 Installing plugin '$NAME'..."
echo "   URL: $URL"
echo ""

# Clone repository
if ! git clone --quiet "$URL" "$PLUGIN_PATH" 2>/dev/null; then
    echo "❌ Error: Failed to clone repository"
    echo "   Check if the URL is valid and accessible"
    exit 1
fi

# Verify plugin.mk exists
if [ ! -f "$PLUGIN_PATH/plugin.mk" ]; then
    echo "❌ Error: Invalid plugin - missing plugin.mk file"
    rm -rf "$PLUGIN_PATH"
    exit 1
fi

# Get commit hash
cd "$PLUGIN_PATH"
COMMIT_HASH=$(git rev-parse --short HEAD)
cd - > /dev/null

# Get current date
INSTALL_DATE=$(date +%Y-%m-%d)

# Add to registry
echo "${NAME}|${URL}|${INSTALL_DATE}|${COMMIT_HASH}" >> "$REGISTRY"

echo "✅ Plugin '$NAME' installed successfully!"
echo ""
echo "📋 Available commands:"
grep -E "^[a-zA-Z_-]+:.*?## " "$PLUGIN_PATH/plugin.mk" | sed 's/:.*##/  -/' || echo "   (no commands with descriptions found)"
echo ""
echo "Run 'makez help' to see all commands"
