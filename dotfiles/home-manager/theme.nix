{ pkgs, lib, ... }:

{
  # Catppuccin Macchiato theme configuration

  # GTK Theme Configuration
  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "macchiato";
      };
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    cursorTheme = {
      package = pkgs.catppuccin-cursors.macchiatoDark;
      name = "Catppuccin-Macchiato-Dark-Cursors";
      size = 24;
    };

    font = {
      name = "JetBrains Mono";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 1;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # DConf settings for GTK theme application in Hyprland
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Macchiato-Standard-Blue-Dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Catppuccin-Macchiato-Dark-Cursors";
      color-scheme = "prefer-dark";
      font-name = "JetBrains Mono 11";
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = "Catppuccin-Macchiato-Standard-Blue-Dark";
    };
  };

  # Qt Theme Configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # Home packages for theming
  home.packages = with pkgs; [
    # Core theme packages
    catppuccin-gtk
    papirus-icon-theme
    catppuccin-cursors

    # GTK theme tools
    nwg-look
    lxappearance
    dconf
    glib # For gsettings

    # Qt theme tools
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    qt6ct

    # Icon and cursor themes
    papirus-icon-theme
    adwaita-icon-theme
  ];

  # Environment variables for consistent theming
  home.sessionVariables = {
    # GTK theming
    GTK_THEME = "Catppuccin-Macchiato-Standard-Blue-Dark";

    # Qt theming
    QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
    QT_STYLE_OVERRIDE = "adwaita-dark";

    # Cursor theming
    XCURSOR_THEME = "Catppuccin-Macchiato-Dark-Cursors";
    XCURSOR_SIZE = "24";

    # Color support for terminals and applications
    TERM = "xterm-256color";
    COLORTERM = "truecolor";
    FORCE_COLOR = "1";
    CLICOLOR = "1";
    CLICOLOR_FORCE = "1";

    # Ensure proper color support for zsh and p10k
    ZSH_HIGHLIGHT_HIGHLIGHTERS = "main,brackets,pattern,line,cursor,root";
    LS_COLORS = "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43";
  };

  # XDG settings for proper theme application
  xdg.configFile = {
    # Kvantum theme config
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Macchiato-Blue
    '';

    # Qt5ct config
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      color_scheme_path=${pkgs.catppuccin-gtk}/share/themes/Catppuccin-Macchiato-Standard-Blue-Dark/gtk-3.0/gtk.css
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=gtk3
      style=gtk2

      [Fonts]
      fixed="JetBrains Mono,11,-1,5,50,0,0,0,0,0"
      general="JetBrains Mono,11,-1,5,50,0,0,0,0,0"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray()
    '';

    # Qt6ct config
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=${pkgs.catppuccin-gtk}/share/themes/Catppuccin-Macchiato-Standard-Blue-Dark/gtk-3.0/gtk.css
      custom_palette=false
      icon_theme=Papirus-Dark
      standard_dialogs=gtk3
      style=gtk2

      [Fonts]
      fixed="JetBrains Mono,11,-1,5,50,0,0,0,0,0"
      general="JetBrains Mono,11,-1,5,50,0,0,0,0,0"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray()
    '';
  };

  # Catppuccin colors for reference (Macchiato palette)
  home.file.".config/catppuccin/macchiato.conf".text = ''
    # Catppuccin Macchiato Color Palette

    # Base colors
    base     = #24273a
    mantle   = #1e2030
    crust    = #181926

    # Surface colors
    surface0 = #363a4f
    surface1 = #494d64
    surface2 = #5b6078

    # Overlay colors
    overlay0 = #6e738d
    overlay1 = #8087a2
    overlay2 = #939ab7

    # Text colors
    subtext0 = #a5adcb
    subtext1 = #b7bdf8
    text     = #cad3f5

    # Accent colors
    lavender = #b7bdf8
    blue     = #8aadf4
    sapphire = #7dc4e4
    sky      = #91d7e3
    teal     = #8bd5ca
    green    = #a6da95
    yellow   = #eed49f
    peach    = #f5a97f
    maroon   = #ee99a0
    red      = #ed8796
    mauve    = #c6a0f6
    pink     = #f5bde6
    flamingo = #f0c6c6
    rosewater = #f4dbd6
  '';
}
