{ pkgs, lib, inputs, config, homeUser, ... }:

{
  home.username = homeUser;
  home.homeDirectory = "/home/${homeUser}";

  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  # Stylix configuration for home-manager
  stylix = {
    enable = true;
    image = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 1.0;
    };

    targets = {
      gtk.enable = true;
      gnome.enable = false;
      nvf.enable = true;
      qt.enable = false;
    };
  };

  home.packages = with pkgs; [
    # Zsh and related packages
    zsh-powerlevel10k

    # Hyprland-related packages
    wofi
    grim
    slurp
    swappy
    jq
    swaynotificationcenter
    wl-clipboard
    libnotify
    playerctl
    brightnessctl
    font-awesome

    # TUI file manager with vim motions
    yazi
    ffmpegthumbnailer  # For video thumbnails
    fd                 # For file searching
    ripgrep           # For content searching
    fzf               # For fuzzy finding
    zoxide            # For directory jumping
  ];
  home.sessionVariables = {
    SUDO_EDITOR = "nvim";
    KUBECONFIG = "$HOME/.kube/config";
  };

  home.file = {
    "Pictures/.keep".text = "";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/p10k.zsh";
    ".config/xdg-desktop-portal-wlr/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/config/xdg-desktop-portal-wlr/config";
  };

  programs.home-manager.enable = true;

  # Override Stylix GTK theme with Orchis (actively maintained)
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Orchis-Dark";
      package = lib.mkForce pkgs.orchis-theme;
    };
    iconTheme = {
      name = lib.mkForce "Papirus-Dark";
      package = lib.mkForce pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = lib.mkForce "Bibata-Modern-Classic";
      package = lib.mkForce pkgs.bibata-cursors;
      size = lib.mkForce 24;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  imports = [
    ./dotfiles/home-manager
  ];

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      comment = "All-in-one cross-platform voice and text chat for gamers";
      exec = "discord";
      icon = "discord";
      type = "Application";
      categories = [ "Network" "InstantMessaging" ];
      mimeType = [ "x-scheme-handler/discord" ];
    };

    brave = {
      name = "Brave Web Browser";
      genericName = "Web Browser";
      comment = "Access the Internet";
      exec = "brave";
      icon = "brave-browser";
      type = "Application";
      categories = [ "Network" "WebBrowser" ];
      mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/ftp" "x-scheme-handler/chrome" "video/webm" "application/x-xpinstall" ];
    };

    signal-desktop = {
      name = "Signal";
      genericName = "Secure messenger";
      comment = "Private messaging from your desktop";
      exec = "signal-desktop";
      icon = "signal-desktop";
      type = "Application";
      categories = [ "Network" "InstantMessaging" ];
      mimeType = [ "x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha" ];
    };

    code = {
      name = "Code";
      genericName = "Project Picker";
      comment = "Open project in Zed using Yazi";
      exec = "ghostty -e zed-project-picker";
      icon = "zed";
      type = "Application";
      categories = [ "Development" "FileManager" ];
      startupNotify = false;
      noDisplay = false;
    };
  };
}
