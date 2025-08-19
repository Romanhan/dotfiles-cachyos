function web2app-list
    echo "📱 Installed web apps:"
    echo "====================="
    
    set -l found_any false
    set -l desktop_files (find "$HOME/.local/share/applications/" -name "*.desktop" -type f 2>/dev/null)
    
    for file in $desktop_files
        set -l app_name (basename "$file" .desktop)
        
        if test -f "$file"
            set -l exec_line (grep "^Exec=" "$file" 2>/dev/null)
            
            # Check if it's a web app (contains URL)
            if string match -q "*http*" "$exec_line"
                set found_any true
                set -l url (echo "$exec_line" | sed -n 's/.*\(https\?:\/\/[^"]*\).*/\1/p')
                set -l browser (echo "$exec_line" | sed 's/Exec=\([^ ]*\).*/\1/' | xargs basename)
                echo "  🌐 $app_name"
                echo "     └── $url ($browser)"
            end
        end
    end
    
    if not $found_any
        echo "  (No web apps found)"
        echo ""
        echo "💡 Create one with: web2app 'AppName' 'https://example.com' 'https://icon-url.png'"
    end
end
