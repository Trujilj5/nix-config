{ config, pkgs, lib, ... }:

{
  # Gaming-specific system configuration
  
  # Enable gamemode for performance optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        reaper_freq = 5;
        desiredgov = "performance";
        igpu_desiredgov = "performance";
        igpu_power_threshold = -1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # Enable Steam and gaming services
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Graphics drivers - AMD (current) and NVIDIA (future)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD drivers
      amdvlk
      rocmPackages.clr.icd
      # Vulkan support
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    extraPackages32 = with pkgs; [
      # 32-bit AMD drivers for gaming compatibility
      driversi686Linux.amdvlk
      # 32-bit Vulkan support
      pkgsi686Linux.vulkan-loader
    ];
  };

  # NVIDIA support (commented out - uncomment when switching to RTX 4060)
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # Wine and compatibility layers
  environment.systemPackages = with pkgs; [
    # Gaming platforms and launchers
    lutris
    heroic
    bottles
    (import ./battlenet-launcher.nix { inherit pkgs; })
    
    # Wine and compatibility
    wine
    wine64
    winetricks
    protontricks
    
    # Gaming utilities
    gamemode
    gamescope
    mangohud
    goverlay
    
    # Additional tools for Battle.net/WoW
    dxvk
    vkd3d
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    mesa.drivers
    
    # System monitoring for gaming
    htop
    nvtopPackages.full
    
    # Audio for gaming
    pulseaudio
    pavucontrol
  ];

  # Gaming-optimized kernel parameters
  boot.kernel.sysctl = {
    # Improve gaming performance
    "vm.max_map_count" = 2147483642;
    "fs.file-max" = 2097152;
    "kernel.sched_autogroup_enabled" = 0;
  };

  # Enable 32-bit support for gaming
  services.pulseaudio.support32Bit = true;

  # Optimize for gaming
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
    {
      domain = "@users";
      item = "nice";
      type = "-";
      value = -10;
    }
    {
      domain = "@users";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];

  # Gaming-related services
  services.ratbagd.enable = true; # For gaming mouse configuration
  programs.corectrl.enable = true; # GPU/CPU control for AMD
  
  # Udev rules for gaming devices
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # Firewall exceptions for gaming
  networking.firewall = {
    allowedTCPPorts = [ 
      27036 27037 # Steam Remote Play
      1119 # Battle.net
    ];
    allowedUDPPorts = [ 
      27031 27036 # Steam
      1119 6113 6114 # Battle.net
    ];
  };

  # Enable controller support
  hardware.xpadneo.enable = true; # Xbox controller support
  services.joycond.enable = true; # Nintendo controller support

  # Performance tweaks
  powerManagement.cpuFreqGovernor = "performance";
  
  # Gaming-specific environment variables
  environment.sessionVariables = {
    # AMD GPU variables
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    
    # Wine/gaming variables
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";
    
    # Enable MangoHud by default
    MANGOHUD = "1";
    
    # Lutris optimizations
    DXVK_HUD = "fps,memory,gpuload";
    DXVK_LOG_LEVEL = "info";
    
    # Vulkan optimizations
    RADV_DEBUG = "llvm";
    MESA_VK_VERSION_OVERRIDE = "1.3";
    
    # Enable Wayland support for Steam
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  # Users in gaming groups
  users.users.john.extraGroups = [ "gamemode" "input" ];
}