{ pkgs, ... }:

pkgs.writeShellScriptBin "battlenet-launcher" ''
  #!/usr/bin/env bash
  
  # Battle.net Launcher Script for NixOS
  # Optimized for WoW and other Blizzard games
  
  export WINEPREFIX="$HOME/.wine-battlenet"
  export WINEARCH="win64"
  export WINE_LARGE_ADDRESS_AWARE=1
  
  # Gaming optimizations
  export __GL_SHADER_DISK_CACHE=1
  export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/nvidia"
  export DXVK_HUD="fps,memory,gpuload"
  export MANGOHUD=1
  export MANGOHUD_CONFIG="fps,cpu_temp,gpu_temp,ram,vram"
  
  # AMD GPU optimizations (comment out when using NVIDIA)
  export RADV_PERFTEST="aco,llvm"
  export AMD_VULKAN_ICD="RADV"
  export MESA_VK_VERSION_OVERRIDE="1.3"
  
  # NVIDIA GPU optimizations (uncomment when using RTX 4060)
  # export __GL_SYNC_TO_VBLANK=0
  # export __GL_THREADED_OPTIMIZATIONS=1
  # export NVIDIA_THREADED_OPTIMIZATIONS=1
  
  # Wine optimizations
  export WINE_CPU_TOPOLOGY="4:2"  # Adjust based on your CPU
  export WINEFSYNC=1
  export WINEESYNC=1
  
  # Create wine prefix if it doesn't exist
  if [ ! -d "$WINEPREFIX" ]; then
    echo "Creating Wine prefix for Battle.net..."
    wineboot --init
    
    # Install required Windows components
    winetricks -q vcrun2019 vcrun2022 corefonts
    winetricks -q dxvk vkd3d
    
    # Set Windows version to Windows 10
    winecfg
  fi
  
  # Check if Battle.net is already installed
  BATTLENET_EXE="$WINEPREFIX/drive_c/Program Files (x86)/Battle.net/Battle.net Launcher.exe"
  
  if [ ! -f "$BATTLENET_EXE" ]; then
    echo "Battle.net not found. Please install it first."
    echo "Download from: https://www.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
    echo "Then run: wine Battle.net-Setup.exe"
    exit 1
  fi
  
  # Enable gamemode if available
  if command -v gamemoderun &> /dev/null; then
    echo "Starting Battle.net with GameMode..."
    gamemoderun wine "$BATTLENET_EXE" "$@"
  else
    echo "Starting Battle.net..."
    wine "$BATTLENET_EXE" "$@"
  fi
''