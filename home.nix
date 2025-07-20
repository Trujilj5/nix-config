{ pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "john";
  home.homeDirectory = "/home/john";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Disable nixpkgs release check to avoid version mismatch warnings
  home.enableNixpkgsReleaseCheck = false;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Zsh and related packages
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-completions

    # Hyprland-related packages
    wofi
    hyprshot
    swaynotificationcenter
    ghostty
    wl-clipboard
    rofi-wayland
    libnotify
    playerctl
    brightnessctl
    font-awesome

    # Other useful packages
    # git # Usually installed system-wide
    # curl # Usually installed system-wide
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/john/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    SUDO_EDITOR = "nvim";
    # Essential environment variables for GTK theme detection
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Manage configuration files
  home.file = {
    # Create Pictures directory for wallpapers
    "Pictures/.keep".text = "";

    # P10k configuration
    ".p10k.zsh".source = ./dotfiles/config/p10k.zsh;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Override Stylix GTK theme with Catppuccin
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Catppuccin-Macchiato-Standard-Blue-Dark";
      package = lib.mkForce (pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "macchiato";
      });
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
  };

  # Import dotfiles configurations
  imports = [
    ./dotfiles/home-manager
  ];

  # Desktop entries for wrapper scripts so they appear in wofi
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
  };




}
