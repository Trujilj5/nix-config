# Neovim Plugin Management Structure

This configuration uses a hybrid approach combining Nix and Lazy.nvim for optimal plugin management.

## Plugin Management Strategy

### 🏗️ **Nix-Managed Plugins** (Core functionality)
These plugins are managed by Nix for better reproducibility and faster startup:

- **LSP & Completion**: `nvim-lspconfig`, `nvim-cmp`, `cmp-*` sources, `luasnip`
- **Telescope**: `telescope.nvim`, `telescope-ui-select.nvim`, `plenary.nvim`
- **Treesitter**: `nvim-treesitter` (with all grammars)
- **Formatting**: `conform.nvim`
- **Git**: `gitsigns.nvim`
- **UI**: `lualine.nvim`, `nvim-web-devicons`
- **Colorscheme**: `base16-nvim` (managed by Stylix)

### 🚀 **Lazy.nvim-Managed Plugins** (Complex UI/UX)
These plugins remain in Lazy.nvim for their complex configurations:

- **Dashboard**: `alpha.nvim` - Complex startup screen
- **Buffer Management**: `barbar.nvim` - Advanced buffer tabs
- **File Explorer**: `neo-tree.nvim` - Feature-rich file tree
- **Git Integration**: `lazygit.nvim` - Git TUI integration
- **Key Bindings**: `which-key.nvim` - Key binding help
- **Fallback Theme**: `catppuccin` - Backup colorscheme

## File Structure

```
lua/
├── vim-options.lua           # Core Vim settings and keybinds
└── plugins/
    ├── README.md            # This file
    ├── alpha.lua            # Lazy: Dashboard configuration
    ├── buffer-tabs.lua      # Lazy: Buffer management
    ├── catppuccin.lua       # Lazy: Fallback colorscheme
    ├── lazy-git.lua         # Lazy: Git integration
    ├── neotree.lua          # Lazy: File explorer
    ├── which-key.lua        # Lazy: Key binding help
    └── *.lua.nix-managed    # Backup of old plugin configs
```

## Benefits of This Approach

### ✅ **Nix-Managed Plugins**
- **Reproducible**: Exact versions across all machines
- **Fast startup**: No runtime downloading or compilation
- **System integration**: Better integration with system tools
- **Declarative**: Configuration as code
- **Offline**: Works without internet

### ✅ **Lazy.nvim for Complex Plugins**
- **Lazy loading**: Faster startup for complex plugins
- **Rich configuration**: Advanced setup options
- **Community configs**: Easy to adapt community configurations
- **Dynamic features**: Runtime customization

## LSP & Tools

All language servers and development tools are managed by Nix:

- **Language Servers**: lua-language-server, typescript-language-server, etc.
- **Formatters**: stylua, prettier, black, etc.
- **Tools**: ripgrep, fd, lazygit, etc.

No more Mason! Everything is declaratively managed and reproducible.

## Migration Notes

Old plugin configurations have been moved to `*.nix-managed` files for reference.
The new setup provides the same functionality with better reproducibility.

## Customization

- **Add Nix plugins**: Edit `nixos/dotfiles/home-manager/nvim.nix`
- **Add Lazy plugins**: Create new files in `plugins/` directory
- **Modify settings**: Edit `vim-options.lua`
