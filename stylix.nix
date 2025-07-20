# stylix.nix - System-wide theming configuration using Stylix
{ pkgs, ... }:

{
  stylix = {
    enable = true;
    
    # Disable version mismatch warnings since we're using matching 25.05 versions
    enableReleaseChecks = false;
    
    # Set a wallpaper - Stylix will generate colors from this if no base16Scheme is set
    # You can replace this with your own wallpaper path from ./wallpapers/
    # For now, using a fetched wallpaper - you can change this to ./wallpapers/your-wallpaper.jpg
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/tropic_island_night.png";
      hash = "sha256-T5Wtjkh6mDpSEz/3I4QYQKOyVVIW5WEONByNhFLEGmU=";
    };
    
    # Alternative: Use a local wallpaper
    # image = ./wallpapers/your-wallpaper.jpg;

    # Use Catppuccin Macchiato color scheme (similar to your previous setup)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

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

    # Let Stylix auto-detect and enable appropriate targets
  };

  # Ensure proper color support in terminals
  environment.variables = {
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
  };
}