# Neovim Configuration Migration to NVF

## Overview

This document outlines the successful migration from a traditional Lazy.nvim-based Neovim configuration to a fully declarative NixOS setup using [nvf (neovim-flake)](https://github.com/NotAShelf/nvf).

## What Was Migrated

### From Lua Plugins to NVF Modules

| Original Plugin | NVF Equivalent | Purpose |
|----------------|----------------|---------|
| `lazy.nvim` | Built-in nvf management | Plugin management |
| `alpha-nvim` | `dashboard.alpha` | Start screen dashboard |
| `barbar.nvim` | `tabline.nvimBufferline` | Buffer tabs |
| `neo-tree.nvim` | `filetree.nvimTree` | File explorer |
| `lazygit.nvim` | `terminal.toggleterm.lazygit` | Git integration |
| `which-key.nvim` | `binds.whichKey` | Keybinding hints |
| `lualine.nvim` | `statusline.lualine` | Status line |
| `nvim-cmp` | `autocomplete.nvim-cmp` | Auto-completion |
| `telescope.nvim` | `telescope` | Fuzzy finder |
| `nvim-treesitter` | `treesitter` | Syntax highlighting |
| `gitsigns.nvim` | `git.gitsigns` | Git integration |
| `comment.nvim` | `comments.comment-nvim` | Code commenting |
| `nvim-autopairs` | `autopairs.nvim-autopairs` | Auto-pairing |

### Configuration Changes

#### File Structure
- **Before**: `~/.config/nvim/` with Lua files
- **After**: Declarative configuration in `nixos/dotfiles/home-manager/nvim.nix`

#### Plugin Management
- **Before**: Lazy.nvim managing plugin downloads and loading
- **After**: Nix flake managing all dependencies declaratively

#### Theming Integration
- **Before**: Manual theme configuration
- **After**: Automatic integration with Stylix system theming

## Key Benefits Achieved

### 1. Reproducibility
- Entire Neovim setup is now version-controlled and reproducible
- No more "works on my machine" issues
- Easy to replicate on new systems

### 2. System Integration
- Seamless integration with NixOS package management
- Automatic dependency resolution
- No conflicting plugin versions

### 3. Declarative Configuration
- All settings defined in Nix configuration
- Easy to enable/disable features
- Clear dependency relationships

### 4. Maintenance
- No manual plugin updates required
- System-wide updates handle everything
- Rollback capability through NixOS generations

## Configuration Highlights

### Language Support
Enabled LSP, formatting, and TreeSitter for:
- Nix
- Lua
- Python
- Rust
- YAML
- Bash

### Key Features
- **Leader Key**: Space (` `)
- **File Navigation**: `<leader>ff` (find files), `<leader>fw` (search text)
- **Git Integration**: `<leader>lg` (LazyGit), `<leader>gs` (git status)
- **Buffer Management**: `<leader>n` (next), `<leader>p` (previous), `<leader>x` (close)
- **LSP Actions**: `<leader>gd` (definition), `<leader>gr` (references), `<leader>ga` (actions)
- **Quick Access**: `<leader>e` (file tree), `<leader>t` (terminal)

### Enhanced Navigation
- Centered cursor after scrolling (`<C-d>`, `<C-u>`)
- Centered search results (`n`, `N`)
- System clipboard integration (`<leader>y`)
- Quick insert mode exit (`jk`)

## Migration Process

### 1. Plugin Analysis
- Identified all active Lua plugins
- Mapped each to nvf equivalent or alternative
- Documented configuration requirements

### 2. Configuration Translation
- Converted Lua keybindings to nvf map format
- Translated vim options to nvf options structure
- Adapted plugin configurations to nvf syntax

### 3. Conflict Resolution
- Disabled original Lua configuration files
- Resolved nvf option compatibility issues
- Ensured Stylix theme integration

### 4. Testing and Validation
- Validated configuration with `nix flake check`
- Tested core functionality
- Verified keybinding consistency

## Files Modified

### Created/Updated
- `nixos/dotfiles/home-manager/nvim.nix` - Main nvf configuration
- `nixos/home.nix` - Added lazygit package dependency

### Disabled (Renamed)
- `nixos/dotfiles/config/nvim/init.lua.disabled`
- `nixos/dotfiles/config/nvim/lua/vim-options.lua.disabled`
- `nixos/dotfiles/config/nvim/lua/plugins/*.lua.disabled`

## Usage Instructions

### Applying the Configuration
```bash
# Test the configuration
cd nixos
nix flake check

# Apply changes (user handles system rebuilds)
sudo nixos-rebuild switch --flake .#default
```

### Customization
Edit `nixos/dotfiles/home-manager/nvim.nix` to:
- Add new language support
- Modify keybindings
- Enable additional nvf modules
- Adjust editor behavior

### Adding New Languages
```nix
languages = {
  # Add to existing configuration
  typescript.enable = true;  # If supported by nvf
  javascript.enable = true;  # If supported by nvf
};
```

## Troubleshooting

### Common Issues
1. **Configuration not loading**: Ensure nvf is properly imported in flake.nix
2. **Missing keybindings**: Check nvf option names in documentation
3. **Plugin conflicts**: Verify old Lua configs are disabled

### Resources
- [nvf Documentation](https://notashelf.github.io/nvf/)
- [nvf Options Reference](https://notashelf.github.io/nvf/options.html)
- [nvf GitHub Repository](https://github.com/NotAShelf/nvf)

## Future Enhancements

### Potential Additions
- Additional language servers as needed
- Custom nvf modules for unsupported plugins
- Advanced LazyGit integration with custom terminal setup
- More sophisticated which-key group configurations

### Monitoring
- Watch nvf releases for new features
- Monitor Stylix integration improvements
- Track nixpkgs updates for plugin versions

---

**Migration Status**: ✅ Complete
**Date**: $(date)
**Configuration Type**: Declarative NVF
**System Integration**: Full NixOS + Home Manager + Stylix