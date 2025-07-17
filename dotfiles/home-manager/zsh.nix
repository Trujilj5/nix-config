{ config, pkgs, inputs, ... }:

{
  # Configure zsh through Home Manager
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Vi mode bindings
    defaultKeymap = "viins";

    # Shell aliases - your existing aliases
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixos#default";
      "update --upgrade" = "sudo nix flake update && update";
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
    };

    # History configuration
    history = {
      size = 500;
      save = 1000;
      path = "${config.home.homeDirectory}/.zshHistFile";
    };

    # Complete zsh setup matching original configuration
    initContent = ''
      # Enable instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "$HOME/.cache/p10k-instant-prompt-$USER.zsh" ]]; then
        source "$HOME/.cache/p10k-instant-prompt-$USER.zsh"
      fi

      # Color support and terminal configuration
      export TERM="xterm-256color"
      export COLORTERM="truecolor"

      # Force color output for various tools
      export FORCE_COLOR=1
      export CLICOLOR=1
      export CLICOLOR_FORCE=1

      # Initialize color support
      autoload -U colors && colors

      # Load Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Autosuggestions configuration
      export ZSH_AUTOSUGGEST_STRATEGY=(history)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

      # Completion setup
      autoload -Uz compinit
      compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' file-sort name
      zstyle ':completion:*' list-colors ""

      # Vi mode
      bindkey -v

      # Key bindings for zsh autosuggestions and completion
      bindkey '^I' complete-word  # Tab for completion
      bindkey '^[[C' autosuggest-accept  # Right arrow accepts suggestion
      bindkey '^[[A' up-line-or-history  # Up arrow for history
      bindkey '^[[B' down-line-or-history  # Down arrow for history
      bindkey '^E' autosuggest-accept  # End key accepts suggestion
      bindkey '^F' autosuggest-accept  # Ctrl+F accepts suggestion

      # Additional autosuggestion bindings
      bindkey '^Y' autosuggest-accept  # Ctrl+Y accepts suggestion
      bindkey '^N' autosuggest-execute  # Ctrl+N accepts and executes suggestion

      # Cursor shape changes for vi mode
      function zle-keymap-select {
        if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
          # Block cursor for normal mode
          echo -ne '\e[2 q'
        elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ -z $KEYMAP ]] || [[ $1 == 'beam' ]]; then
          # Beam cursor for insert mode
          echo -ne '\e[6 q'
        fi
      }
      zle -N zle-keymap-select

      # Initialize cursor shape
      zle-line-init() {
        echo -ne '\e[6 q'
      }
      zle -N zle-line-init

      # Restore cursor shape when command is done
      preexec() {
        echo -ne '\e[6 q'
      }

      # Load p10k configuration
      source ${builtins.toString ../config/p10k.zsh}
    '';
  };
}
