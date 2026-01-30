#!/bin/bash

# Central plugin directory (like ASDF)
PLUGINS_DIR="$HOME/.makez/plugins"
REGISTRY="$PLUGINS_DIR/.registry"

# Check if registry exists and has plugins
if [ ! -f "$REGISTRY" ] || [ ! -s "$REGISTRY" ] || [ $(grep -v "^#" "$REGISTRY" | wc -l) -eq 0 ]; then
    echo "No plugins installed. Install with: makez plugin-install URL=<git-url>"
    exit 0
fi

COUNT=0
while IFS='|' read -r name url date commit; do
    [[ "$name" =~ ^#.*$ ]] && continue
    COUNT=$((COUNT + 1))

    echo "$name (installed $date, commit $commit)"

    PLUGIN_MK="$PLUGINS_DIR/$name/plugin.mk"
    if [ -f "$PLUGIN_MK" ]; then
        COMMANDS=$(grep -E "^[a-zA-Z_-]+:.*?## " "$PLUGIN_MK" | sed 's/:.*##//' | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//')
        [ -n "$COMMANDS" ] && echo "  Commands: $COMMANDS"
    fi
done < "$REGISTRY"

echo ""
echo "Total: $COUNT plugin(s)"
