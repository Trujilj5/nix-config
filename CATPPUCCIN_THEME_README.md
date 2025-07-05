# 🎨 Catppuccin Macchiato Theme for NixOS + Hyprland

This guide explains how to set up the beautiful Catppuccin Macchiato theme for your NixOS system with Hyprland window manager.

## 📋 What's Included

This theme setup configures:

- **GTK Applications**: Catppuccin Macchiato Dark theme with blue accents
- **Icons**: Papirus Dark icons with Catppuccin folder colors
- **Cursors**: Catppuccin Macchiato blue cursors
- **Hyprland**: Window manager colors and styling
- **Waybar**: Status bar with Catppuccin colors
- **Qt Applications**: Themed to match GTK applications
- **Fonts**: JetBrains Mono throughout the system

## 🚀 Quick Setup

1. **Automatic Setup** (Recommended):
   ```bash
   ./setup-catppuccin-theme.sh
   ```
   This script will rebuild your system and apply all theme configurations.

2. **Manual Setup**:
   ```bash
   # Rebuild NixOS system
   sudo nixos-rebuild switch --flake .
   
   # Rebuild Home Manager
   home-manager switch --flake .
   
   # Restart Hyprland services
   pkill hyprpaper waybar
   hyprpaper &
   waybar &
   ```

## 🎨 Color Palette

The Catppuccin Macchiato palette includes:

| Color | Hex | Usage |
|-------|-----|-------|
| **Base** | `#24273a` | Main background |
| **Surface0** | `#363a4f` | Secondary background |
| **Blue** | `#8aadf4` | Primary accent (active windows, buttons) |
| **Text** | `#cad3f5` | Primary text |
| **Red** | `#ed8796` | Urgent/error states |
| **Green** | `#a6da95` | Success states |
| **Yellow** | `#eed49f` | Warning states |
| **Pink** | `#f5bde6` | Hover states |
| **Mauve** | `#c6a0f6` | Secondary accent |

## 🔧 Configuration Files

The theme is configured through several files:

### Core Theme Configuration
- `dotfiles/home-manager/theme.nix` - Main theme configuration
- `home.nix` - Imports theme configuration
- `desktop.nix` - System-wide theme packages

### Application Configurations
- `dotfiles/config/hypr/hyprland.conf` - Window manager colors
- `dotfiles/config/waybar/style.css` - Status bar styling
- `~/.config/gtk-3.0/settings.ini` - GTK3 applications
- `~/.config/gtk-4.0/settings.ini` - GTK4 applications

## 🛠️ Theme Management Tools

### GTK Theme Configuration
- **nwg-look**: Modern GTK theme switcher
  ```bash
  nwg-look
  ```

- **lxappearance**: Traditional GTK theme manager
  ```bash
  lxappearance
  ```

### Qt Application Theming
- **qt5ct**: Qt5 configuration tool
  ```bash
  qt5ct
  ```

- **qt6ct**: Qt6 configuration tool
  ```bash
  qt6ct
  ```



## 🔧 Application-Specific Configuration

### Firefox
1. Install [Catppuccin Firefox theme](https://github.com/catppuccin/firefox)
2. Set `toolkit.legacyUserProfileCustomizations.stylesheets = true` in `about:config`

### VSCode/Codium
1. Install the Catppuccin theme extension
2. Select "Catppuccin Macchiato" variant

### Discord
1. Install [Catppuccin Discord theme](https://github.com/catppuccin/discord)
2. Use a theme manager like BetterDiscord or Vencord

### Spotify
1. Install [Spicetify](https://spicetify.app/)
2. Apply [Catppuccin Spotify theme](https://github.com/catppuccin/spicetify)

## 🐛 Troubleshooting

### Theme Not Applied
1. **Restart applications** - Some apps need restart to pick up theme changes
2. **Check environment variables**:
   ```bash
   echo $GTK_THEME
   echo $QT_QPA_PLATFORMTHEME
   ```
3. **Rebuild configurations**:
   ```bash
   sudo nixos-rebuild switch --flake .
   home-manager switch --flake .
   ```

### Cursor Theme Issues
1. **Check cursor size**:
   ```bash
   echo $XCURSOR_SIZE
   ```
2. **Verify cursor theme**:
   ```bash
   echo $XCURSOR_THEME
   ```
3. **Restart Hyprland** for cursor changes to take effect

### Qt Applications Not Themed
1. **Install qt5ct/qt6ct**:
   ```bash
   qt5ct  # Configure Qt5 apps
   qt6ct  # Configure Qt6 apps
   ```
2. **Set environment variables**:
   ```bash
   export QT_QPA_PLATFORMTHEME=qt5ct
   ```

### Waybar Colors Not Applied
1. **Check waybar process**:
   ```bash
   pkill waybar
   waybar &
   ```
2. **Verify CSS file**: Check `~/.config/waybar/style.css`

## 📚 Additional Resources

- [Catppuccin Organization](https://github.com/catppuccin)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

## 🎯 Customization Tips

### Changing Accent Colors
To use a different accent color (e.g., pink instead of blue):

1. Edit `dotfiles/home-manager/theme.nix`:
   ```nix
   theme = {
     package = pkgs.catppuccin-gtk.override {
       accents = [ "pink" ];  # Change from "blue"
       variant = "macchiato";
     };
     name = "Catppuccin-Macchiato-Standard-Pink-Dark";
   };
   ```

2. Update cursor theme:
   ```nix
   cursorTheme = {
     package = pkgs.catppuccin-cursors.macchiato;
     name = "Catppuccin-Macchiato-Pink-Cursors";
   };
   ```

3. Update Hyprland colors in `dotfiles/config/hypr/hyprland.conf`:
   ```conf
   col.active_border = rgba(f5bde6ff)    # Pink instead of blue
   ```

## 🔄 Keeping Themes Updated

The theme configurations are managed through Nix, so updates are handled through:

1. **System updates**:
   ```bash
   sudo nixos-rebuild switch --flake . --upgrade
   ```

2. **Home Manager updates**:
   ```bash
   home-manager switch --flake . --upgrade
   ```

3. **Flake updates**:
   ```bash
   nix flake update
   ```

## 🎨 Contributing

Found an issue or want to improve the theme? Feel free to:
1. Create issues for problems
2. Submit pull requests for improvements
3. Share your customizations

---

**Enjoy your beautiful Catppuccin Macchiato themed desktop!** 🎉