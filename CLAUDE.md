# Project Rules for AI Assistants

## CRITICAL: System Management
- NEVER run system rebuild commands (sudo nixos-rebuild switch/test/boot)
- User handles all system rebuilds and testing
- Configuration = AI responsibility, Application = User responsibility

## File Management
- Keep repository clean and minimal
- NO creating scripts without explicit user permission
- NO creating multiple documentation files
- NO adding unnecessary project files

## Allowed Actions
- Edit .nix configuration files
- Run safe validation: nix flake check
- Provide configuration guidance
- Clean up and organize existing files

## Project Context
- NixOS + Hyprland configuration using flakes
- Home Manager integration
- Stylix for unified theming
- User controls when changes are applied

## Repository Cleanliness
- Minimal file structure
- No redundant documentation
- Focus on functional configuration only