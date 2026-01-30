#!/bin/bash
set -e

NAME="$1"

# Central plugin directory (like ASDF)
PLUGINS_DIR="$HOME/.makez/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Validate NAME
[ -z "$NAME" ] && echo "Error: NAME required. Usage: makez plugin-update NAME=<plugin-name>" && exit 1

# Check if plugin exists
grep -q "^${NAME}|" "$REGISTRY" 2>/dev/null || { echo "Error: Plugin not installed"; exit 1; }

PLUGIN_PATH="$PLUGINS_DIR/$NAME"
[ ! -d "$PLUGIN_PATH" ] && echo "Error: Plugin directory not found" && exit 1

echo "Updating $NAME..."

# Get current commit
cd "$PLUGIN_PATH"
OLD_COMMIT=$(git rev-parse --short HEAD)

# Pull latest changes
git pull --quiet 2>/dev/null || { echo "Error: Update failed. Check connection or reinstall"; exit 1; }

NEW_COMMIT=$(git rev-parse --short HEAD)

# Check if updated
[ "$OLD_COMMIT" = "$NEW_COMMIT" ] && echo "Already up to date ($NEW_COMMIT)" && exit 0

# Update registry
while IFS='|' read -r name url date commit; do
    [ "$name" = "$NAME" ] && echo "${name}|${url}|${date}|${NEW_COMMIT}" || echo "${name}|${url}|${date}|${commit}"
done < "$REGISTRY" > "$REGISTRY.tmp" && mv "$REGISTRY.tmp" "$REGISTRY"

echo "Updated successfully: $OLD_COMMIT -> $NEW_COMMIT"
