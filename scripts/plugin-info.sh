#!/bin/bash

NAME="$1"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAKEZ_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$MAKEZ_DIR/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate NAME
if [ -z "$NAME" ]; then
    echo "Error: NAME is required"
    echo "Usage: makez plugin-info NAME=<plugin-name>"
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

# Get plugin info from registry
INFO=$(grep "^${NAME}|" "$REGISTRY")
IFS='|' read -r _ url date commit <<< "$INFO"

echo ""
echo "Plugin: $NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Details:"
echo "  URL: $url"
echo "  Installed: $date"
echo "  Commit: $commit"
echo "  Path: $PLUGIN_PATH"
echo ""

# Show available commands
echo "Available Commands:"
PLUGIN_MK="$PLUGIN_PATH/plugin.mk"
if [ -f "$PLUGIN_MK" ]; then
    grep -E "^[a-zA-Z_-]+:.*?## " "$PLUGIN_MK" | sed 's/:.*##/  -/' || echo "  (no commands with descriptions found)"
else
    echo "  Warning: plugin.mk not found"
fi
echo ""

# Show README if exists
README="$PLUGIN_PATH/README.md"
if [ -f "$README" ]; then
    echo "README (first 15 lines):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    head -15 "$README" | sed 's/^/  /'
    LINE_COUNT=$(wc -l < "$README")
    if [ "$LINE_COUNT" -gt 15 ]; then
        echo "  ... ($(($LINE_COUNT - 15)) more lines)"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

# Show recent commits
echo "Recent Commits:"
cd "$PLUGIN_PATH"
git log --oneline --no-decorate -5 | sed 's/^/  /'
echo ""
