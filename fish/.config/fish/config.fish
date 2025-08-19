# Remove the default Fish greeting message that shows on shell startup
set fish_greeting

# Initialize Starship prompt (replaces default Fish prompt with customizable one)
starship init fish | source

# Check if SSH agent is not already running (SSH_AUTH_SOCK variable doesn't exist)
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null
    ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
end
