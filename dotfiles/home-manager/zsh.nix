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
      zed = "zed-fhs .";
      "zed." = "zed-fhs . && exit";
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


    '';
  };
}
