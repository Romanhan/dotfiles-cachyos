function web2app-remove
    if test (count $argv) -ne 1
        echo "Usage: web2app-remove <AppName>"
        return 1
    end

    set -l APP_NAME $argv[1]
    set -l ICON_DIR "$HOME/.local/share/applications/icons"
    set -l DESKTOP_FILE "$HOME/.local/share/applications/$APP_NAME.desktop"
    set -l ICON_PATH "$ICON_DIR/$APP_NAME.png"

    echo "🗑️  Removing desktop app '$APP_NAME'..."
    
    if test -f "$DESKTOP_FILE"
        rm "$DESKTOP_FILE"
        echo "✅ Removed launcher: $DESKTOP_FILE"
    else
        echo "⚠️  Launcher not found: $DESKTOP_FILE"
    end
    
    if test -f "$ICON_PATH"
        rm "$ICON_PATH"
        echo "✅ Removed icon: $ICON_PATH"
    else
        echo "⚠️  Icon not found: $ICON_PATH"
    end
    
    echo "🗑️  '$APP_NAME' removed from application menu"
end
