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
    echo "❌ Error: NAME is required"
    echo "Usage: makez plugin-update NAME=<plugin-name>"
    echo ""
    echo "Run 'makez plugin-list' to see installed plugins"
    exit 1
fi

# Check if plugin exists
if ! grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null; then
    echo "❌ Plugin '$NAME' is not installed"
    echo ""
    echo "Run 'makez plugin-list' to see installed plugins"
    exit 1
fi

PLUGIN_PATH="$PLUGINS_DIR/$NAME"

# Check if plugin directory exists
if [ ! -d "$PLUGIN_PATH" ]; then
    echo "❌ Error: Plugin directory not found: $PLUGIN_PATH"
    exit 1
fi

echo "🔄 Updating plugin '$NAME'..."
echo ""

# Get current commit
cd "$PLUGIN_PATH"
OLD_COMMIT=$(git rev-parse --short HEAD)

# Pull latest changes
if ! git pull --quiet 2>/dev/null; then
    echo "❌ Error: Failed to update plugin"
    echo "   Check your internet connection or try reinstalling"
    exit 1
fi

# Get new commit
NEW_COMMIT=$(git rev-parse --short HEAD)

if [ "$OLD_COMMIT" = "$NEW_COMMIT" ]; then
    echo "✅ Plugin '$NAME' is already up to date"
    echo "   Commit: $NEW_COMMIT"
    exit 0
fi

# Show changes
echo "📋 Changes:"
git log --oneline --no-decorate "$OLD_COMMIT..$NEW_COMMIT" | sed 's/^/   /'
echo ""

# Update registry
cd "$MAKEZ_DIR"
TEMP_REGISTRY="$REGISTRY.tmp"
while IFS='|' read -r name url date commit; do
    if [ "$name" = "$NAME" ]; then
        echo "${name}|${url}|${date}|${NEW_COMMIT}"
    else
        echo "${name}|${url}|${date}|${commit}"
    fi
done < "$REGISTRY" > "$TEMP_REGISTRY"
mv "$TEMP_REGISTRY" "$REGISTRY"

echo "✅ Plugin '$NAME' updated successfully!"
echo "   Old commit: $OLD_COMMIT"
echo "   New commit: $NEW_COMMIT"
