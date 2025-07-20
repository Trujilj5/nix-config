# dotfiles/home-manager/wofi.nix - Wofi launcher configuration with Stylix integration
{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    package = pkgs.wofi;
    
    settings = {
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = true;
      term = "ghostty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";
      columns = 2;
      location = "center";
      allow_markup = true;
      allow_images = true;
      image_size = 48;
      gtk_dark = true;
      matching = "fuzzy";
      sort_order = "default";
      no_actions = true;
    };

    style = with config.lib.stylix.colors; ''
      * {
        font-family: '${config.stylix.fonts.monospace.name}', monospace;
        font-size: ${toString config.stylix.fonts.sizes.popups}px;
        font-weight: normal;
      }

      /* Define Catppuccin Macchiato colors using Stylix base16 colors */
      @define-color rosewater #${base06};
      @define-color flamingo #${base06};
      @define-color pink #${base0E};
      @define-color mauve #${base0E};
      @define-color red #${base08};
      @define-color maroon #${base08};
      @define-color peach #${base09};
      @define-color yellow #${base0A};
      @define-color green #${base0B};
      @define-color teal #${base0C};
      @define-color sky #${base0C};
      @define-color sapphire #${base0D};
      @define-color blue #8aadf4;
      @define-color lavender #${base0F};
      @define-color text #${base05};
      @define-color subtext1 #${base04};
      @define-color subtext0 #${base04};
      @define-color overlay2 #${base03};
      @define-color overlay1 #${base03};
      @define-color overlay0 #${base03};
      @define-color surface2 #${base02};
      @define-color surface1 #${base01};
      @define-color surface0 #${base01};
      @define-color base #${base00};
      @define-color mantle #${base00};
      @define-color crust #${base00};

      /* Window */
      window {
        margin: 0px;
        padding: 12px;
        border: 2px solid @blue;
        border-radius: 12px;
        background-color: alpha(@base, ${toString config.stylix.opacity.popups});
        animation: slideIn 0.3s ease-in-out both;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
      }

      /* Slide In Animation */
      @keyframes slideIn {
        0% {
          opacity: 0;
          transform: translateY(-10px);
        }
        100% {
          opacity: 1;
          transform: translateY(0px);
        }
      }

      /* Inner Box */
      #inner-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: transparent;
        animation: fadeIn 0.3s ease-in-out both;
      }

      /* Fade In Animation */
      @keyframes fadeIn {
        0% {
          opacity: 0;
        }
        100% {
          opacity: 1;
        }
      }

      /* Outer Box */
      #outer-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: transparent;
      }

      /* Scroll */
      #scroll {
        margin: 0px;
        padding: 10px;
        border: none;
        background-color: transparent;
      }

      /* Input */
      #input {
        margin: 5px 20px 15px 20px;
        padding: 12px 15px;
        border: 2px solid @surface1;
        border-radius: 6px;
        color: @text;
        background-color: @surface0;
        animation: fadeIn 0.3s ease-in-out both;
        transition: border-color 0.2s ease;
      }

      #input:focus {
        border-color: @blue;
        outline: none;
      }

      #input image {
        border: none;
        color: @red;
        margin-right: 8px;
      }

      /* Text */
      #text {
        margin: 5px;
        border: none;
        color: @text;
        animation: fadeIn 0.3s ease-in-out both;
      }

      /* Entry */
      #entry {
        margin: 2px;
        padding: 8px 12px;
        border: 2px solid transparent;
        border-radius: 6px;
        background-color: transparent;
        transition: all 0.2s ease;
      }

      #entry:hover {
        background-color: @surface1;
        border-color: @surface2;
      }

      #entry arrow {
        border: none;
        color: @blue;
        margin-right: 8px;
      }

      /* Selected Entry */
      #entry:selected {
        background-color: @surface1;
        border-color: @blue;
      }

      #entry:selected #text {
        color: @mauve;
        font-weight: bold;
      }

      #entry:selected arrow {
        color: @mauve;
      }

      #entry:drop(active) {
        background-color: @blue;
        color: @base;
      }

      #entry:drop(active) #text {
        color: @base;
      }

      /* Image styling for app icons */
      #img {
        margin-right: 12px;
        border-radius: 4px;
      }

      /* Scrollbar styling */
      scrollbar {
        background-color: transparent;
        width: 8px;
      }

      scrollbar slider {
        background-color: @overlay0;
        border-radius: 4px;
        margin: 2px;
      }

      scrollbar slider:hover {
        background-color: @overlay1;
      }
    '';
  };

  # Create a wrapper script for easy launching
  home.packages = with pkgs; [
    (writeShellScriptBin "wofi-launcher" ''
      #!/usr/bin/env bash
      
      # Kill any existing wofi instances
      pkill wofi 2>/dev/null
      
      # Launch wofi
      exec ${pkgs.wofi}/bin/wofi
    '')
  ];

  # Optional: Create desktop entry for the launcher
  xdg.desktopEntries.wofi = {
    name = "Wofi Launcher";
    genericName = "Application Launcher";
    comment = "Launch applications with Wofi";
    exec = "wofi-launcher";
    icon = "application-x-executable";
    type = "Application";
    categories = [ "System" "Utility" ];
    noDisplay = true; # Hide from app menus since it's a launcher
  };
}