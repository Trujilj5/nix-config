{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    # Shell aliases
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos#default";
      upgrade = "sudo nix flake update --flake ~/nixos";
      vim = "nvim";
      sudoedit = "sudo -E nvim";
      zed = "zeditor .";
      "zed." = "zed . && exit";
      wip = "git add . && git commit -m 'wip' && git push origin";
      c = "clear";
      nix-shell = "nix-shell --run zsh";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -ltrah";
      lg = "lazygit";
      ".." = "cd ..";
      "..." = "cd ../..";
      kc = "kubectl";
      kcg = "kc get";
      kcd = "kc describe";
      kcga = "kcg all";
      kcgp = "kcg pod";
      kcc = "kc config";
      kccns = "kcc set-context --current --namespace";
      kcgns = "kcg namespace";
      kca = "kc apply";
      kcapply = "kca";
      kcgsa = "kcg serviceaccount";
      kcdp = "kcd pod";
      kcdss = "kcd statefulset";
      kcl = "kc logs";
      kcexec = "kc exec";
      kcrm = "kc delete";
      kcdel = "kcrm";
      kcdelp = "kcrm pod";
      kcrmp = "kcrm pod";
      kcrmss = "kcrm statefulsets";
      kcdelss = "kcrmss";
      kcge = "kcg events";
      kcswap = "kubectl config set-context --current --namespace";
      init-dev = "init_dev_shell";
    };

    # History
    history = {
      size = 500;
      save = 1000;
      path = "${config.home.homeDirectory}/.zshHistFile";
    };

    # Zsh initialization
    initContent = ''
      # Enable instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "$HOME/.cache/p10k-instant-prompt-$USER.zsh" ]]; then
        source "$HOME/.cache/p10k-instant-prompt-$USER.zsh"
      fi

      # Terminal configuration
      export TERM="xterm-256color"
      export COLORTERM="truecolor"

      # Color output
      export FORCE_COLOR=1
      export CLICOLOR=1
      export CLICOLOR_FORCE=1

      # Color support
      autoload -U colors && colors

      # Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Autosuggestions
      export ZSH_AUTOSUGGEST_STRATEGY=(history)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

      # Completion
      autoload -Uz compinit
      compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' file-sort name
      zstyle ':completion:*' list-colors ""

      # Vi mode
      bindkey -v

      # Key bindings
      bindkey '^I' complete-word
      bindkey '^[[C' autosuggest-accept
      bindkey '^[[A' up-line-or-history
      bindkey '^[[B' down-line-or-history
      bindkey '^E' autosuggest-accept
      bindkey '^F' autosuggest-accept
      bindkey '^Y' autosuggest-accept
      bindkey '^N' autosuggest-execute

      # Cursor shape for vi mode
      function zle-keymap-select {
        if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
          # Block cursor
          echo -ne '\e[2 q'
        elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ -z $KEYMAP ]] || [[ $1 == 'beam' ]]; then
          # Beam cursor
          echo -ne '\e[6 q'
        fi
      }
      zle -N zle-keymap-select

      # Initialize cursor
      zle-line-init() {
        echo -ne '\e[6 q'
      }
      zle -N zle-line-init

      # Restore cursor
      preexec() {
        echo -ne '\e[6 q'
      }

      # P10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Zoxide
      eval "$(zoxide init zsh)"

      # Skip direnv and other initialization if we're in an FHS environment
      # to prevent infinite loops
      if [[ -z "$IN_FHS_SHELL" ]]; then
        # Mark that we're not in FHS shell for child processes
        export IN_NIX_SHELL_PARENT=true
      else
        # We're in an FHS environment - skip complex initialization
        return
      fi

      # Interactive development shell initialization
      init_dev_shell() {
        # Get available shells as array
        local shell_list=$(nix flake show ~/nixos/dev-shells --json 2>/dev/null | jq -r '.devShells."x86_64-linux" | keys[]' 2>/dev/null || echo "i-console-dev")

        # Convert to array
        local shells=()
        while IFS= read -r line; do
          [[ -n "$line" ]] && shells+=("$line")
        done <<< "$shell_list"

        # If only one shell, use it directly
        if (( ''${#shells} == 1 )); then
          local selected_shell="''${shells[1]}"
          echo "Using: $selected_shell"
        else
          # Show menu and get selection
          echo "Available development shells:"
          local i=1
          for shell in "''${shells[@]}"; do
            echo "  $i) $shell"
            ((i++))
          done
          echo

          while true; do
            read "choice?Select shell (1-''${#shells}): "
            if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ''${#shells} )); then
              local selected_shell="''${shells[choice]}"
              break
            else
              echo "Invalid selection. Please choose 1-''${#shells}."
            fi
          done
        fi

        # Create .envrc using nix file directly to avoid loops
        echo "use nix ~/nixos/dev-shells/$selected_shell.nix" > .envrc
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
    '';
  };
}
