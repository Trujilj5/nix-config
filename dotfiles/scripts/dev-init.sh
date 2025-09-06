#!/usr/bin/env zsh

# Interactive development shell initialization script
# This script helps select and initialize development environments

init_dev_shell() {
    # Get available shells using simpler approach
    local shell_list
    shell_list=$(nix flake show ~/nixos/dev-shells --json 2>/dev/null | jq -r '.devShells."x86_64-linux" | keys[]' 2>/dev/null || echo "i-console-dev")

    # Convert to simple array using newlines
    local shells=()
    while IFS= read -r shell; do
        [[ -n "$shell" ]] && shells+=("$shell")
    done <<< "$shell_list"

    # Check if we have only one shell
    if [ ${#shells[@]} -eq 1 ]; then
        local selected_shell="${shells[0]}"
        echo "Using: $selected_shell"
    else
        # Show selection menu
        echo "Available development shells:"
        for i in "${!shells[@]}"; do
            echo "  $((i+1))) ${shells[i]}"
        done
        echo ""

        # Get user selection
        while true; do
            read "choice?Select shell (1-${#shells[@]}): "
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#shells[@]}" ]; then
                local selected_shell="${shells[$((choice-1))]}"
                break
            else
                echo "Invalid selection. Please choose 1-${#shells[@]}."
            fi
        done
    fi

    # Create .envrc
    echo "use flake ~/nixos/dev-shells#$selected_shell" > .envrc
    direnv allow
    echo "✅ Initialized $selected_shell development environment"
}

# Dev command dispatcher
dev() {
    case $1 in
        init)
            init_dev_shell
            ;;
        help)
            echo "Usage: dev [init|help]"
            echo "  init - Initialize development shell"
            echo "  help - Show this help message"
            ;;
        *)
            echo "Usage: dev [init|help]"
            echo "  init - Initialize development shell"
            echo "  help - Show this help message"
            ;;
    esac
}

# If script is called directly, run the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    dev "$@"
fi