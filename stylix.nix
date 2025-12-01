{ pkgs, ... }:

{
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    
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
      console.enable = true;
      nvf.enable = true;
      qt.enable = false;
    };
  };

  environment.variables = {
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    gnome-themes-extra
  ];
}