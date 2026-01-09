#!/bin/bash

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAKEZ_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$MAKEZ_DIR/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Check if registry exists and has plugins
if [ ! -f "$REGISTRY" ] || [ ! -s "$REGISTRY" ] || [ $(grep -v "^#" "$REGISTRY" | wc -l) -eq 0 ]; then
    echo "📦 No plugins installed"
    echo ""
    echo "Install a plugin with: makez plugin-install URL=<git-url>"
    exit 0
fi

echo ""
echo "📦 Installed Plugins"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

COUNT=0
while IFS='|' read -r name url date commit; do
    # Skip comment lines
    [[ "$name" =~ ^#.*$ ]] && continue

    COUNT=$((COUNT + 1))

    echo "📌 $name"
    echo "   URL: $url"
    echo "   Installed: $date"
    echo "   Commit: $commit"

    # Show available commands
    PLUGIN_MK="$PLUGINS_DIR/$name/plugin.mk"
    if [ -f "$PLUGIN_MK" ]; then
        COMMANDS=$(grep -E "^[a-zA-Z_-]+:.*?## " "$PLUGIN_MK" | sed 's/:.*##//' | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//')
        if [ -n "$COMMANDS" ]; then
            echo "   Commands: $COMMANDS"
        fi
    fi

    echo ""
done < "$REGISTRY"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total: $COUNT plugin(s) installed"
echo ""
