#!/usr/bin/env fish

# Interactive web2app function - Fish shell version
function web2app
    # Check if we got 3 arguments, if not, prompt interactively
    if test (count $argv) -ne 3
        echo -e "\e[32mLet's create a new web app you can start with the app launcher.\n\e[0m"
        
        # Check if gum is installed for better prompts
        if command -v gum >/dev/null 2>&1
            set APP_NAME (gum input --prompt "Name> " --placeholder "My favorite web app")
            set APP_URL (gum input --prompt "URL> " --placeholder "https://example.com")
            set ICON_URL (gum input --prompt "Icon URL> " --placeholder "See https://dashboardicons.com (must use PNG!)")
        else
            # Fallback to basic read prompts
            echo -n "Name> "
            read APP_NAME
            echo -n "URL> " 
            read APP_URL
            echo -n "Icon URL> "
            read ICON_URL
        end
    else
        set APP_NAME $argv[1]
        set APP_URL $argv[2] 
        set ICON_URL $argv[3]
    end

    # Validate inputs
    if test -z "$APP_NAME" -o -z "$APP_URL" -o -z "$ICON_URL"
        echo "❌ You must set app name, app URL, and icon URL!"
        return 1
    end

    # Set up paths
    set ICON_DIR "$HOME/.local/share/applications/icons"
    set DESKTOP_FILE "$HOME/.local/share/applications/$APP_NAME.desktop"
    set ICON_PATH "$ICON_DIR/$APP_NAME.png"

    # Create icon directory
    mkdir -p "$ICON_DIR"

    # Download icon
    echo "📥 Downloading icon for $APP_NAME..."
    if not curl -sL -o "$ICON_PATH" "$ICON_URL"
        echo "❌ Error: Failed to download icon."
        return 1
    end

    # Create desktop file
    echo "🚀 Creating desktop launcher for $APP_NAME..."
    echo "[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=chromium --new-window --ozone-platform=wayland --app=\"$APP_URL\" --name=\"$APP_NAME\" --class=\"$APP_NAME\"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true" > "$DESKTOP_FILE"

    # Make executable
    chmod +x "$DESKTOP_FILE"

    # Success message
    if test (count $argv) -ne 3
        echo -e "\n✅ You can now find $APP_NAME using the app launcher (SUPER + SPACE)\n"
        echo "🎉 Web app created successfully!"
    else
        echo "✅ Desktop app '$APP_NAME' created successfully!"
        echo "📍 Launcher: $DESKTOP_FILE"
        echo "🎨 Icon: $ICON_PATH"
        echo "🚀 The app should appear in your application menu"
    end
end
