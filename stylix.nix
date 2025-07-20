# stylix.nix - System-wide theming configuration using Stylix
{ pkgs, ... }:

{
  stylix = {
    enable = true;
    
    # Disable version mismatch warnings since we're using matching 25.05 versions
    enableReleaseChecks = false;
    
    # Use a built-in wallpaper to avoid download issues
    # You can replace this with your own wallpaper path from ./wallpapers/
    image = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
    
    # Alternative: Use a local wallpaper
    # image = ./wallpapers/your-wallpaper.jpg;

    # Use Catppuccin Macchiato color scheme (similar to your previous setup)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    
    # Force dark theme preference
    polarity = "dark";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };

    # Cursor configuration
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # Opacity settings
    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 1.0;
    };

    # Target-specific configurations
    targets = {
      # Enable GTK theming for applications like Thunar
      gtk.enable = true;
      
      # Enable GNOME/dconf settings for GTK applications
      gnome.enable = true;
      
      # Enable console theming
      console.enable = true;
      
      # Keep other targets at default (auto-detected)
    };
  };

  # Ensure proper color support in terminals
  environment.variables = {
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
  };

  # Ensure GTK theme packages are available
  environment.systemPackages = with pkgs; [
    (catppuccin-gtk.override {
      accents = [ "blue" ];
      variant = "macchiato";
    })
    papirus-icon-theme
    bibata-cursors
    adwaita-icon-theme
    gnome-themes-extra
  ];
}