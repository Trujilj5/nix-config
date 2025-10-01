# NixOS + LazyVim Configuration

This configuration provides a fully functional LazyVim setup managed through NixOS and Home Manager, based on the approach documented in [LazyVim/LazyVim discussions #1972](https://github.com/LazyVim/LazyVim/discussions/1972).

## How This Setup Works

### Architecture Overview

This setup uses a **dual lazy.nvim configuration pattern** that allows LazyVim to work seamlessly with Nix package management:

1. **Nix Layer** (`dotfiles/home-manager/nvim.nix`):
   - Manages plugin installations via `pkgs.vimPlugins`
   - Creates a `lazyPath` that points to Nix-managed plugins
   - Generates the main `init.lua` with `extraLuaConfig` containing `require("lazy").setup()`
   - Provides LSPs, formatters, and tools via `extraPackages`

2. **Lua Layer** (`dotfiles/config/nvim/lua/`):
   - `config/lazy.lua`: Bootstraps lazy.nvim (downloads if needed, adds to runtime path)
   - `config/keymaps.lua`, `config/options.lua`, `config/autocmds.lua`: LazyVim configuration
   - `plugins/`: Custom plugin configurations that extend or override LazyVim defaults

### Critical Setup Features (DO NOT MODIFY)

⚠️ **The following patterns are essential for this setup to work:**

1. **Dual Lazy Setup**: Both `lazy.lua` AND `nvim.nix` have `require("lazy").setup()` calls
   - `lazy.lua` does basic LazyVim initialization
   - `nvim.nix` reconfigures lazy with Nix plugin paths

2. **Plugin Path Configuration**:
   ```nix
   dev = {
     path = "${lazyPath}",
     patterns = { "" },  # Important: empty string, not "."
     fallback = true,
   }
   ```

3. **File Linking Strategy**:
   ```nix
   xdg.configFile."nvim/lua".source = ../../dotfiles/config/nvim/lua;
   xdg.configFile."nvim/parser".source = "${parsers}/parser";
   ```
   - Links only the `lua/` directory (not the whole `nvim/` directory)
   - Avoids conflicts with Nix-generated `init.lua`

4. **Treesitter Configuration**:
   ```nix
   opts = function(_, opts)
     opts.ensure_installed = {}
     opts.auto_install = false
     return opts
   end
   ```
   - Must use function-based opts to override LazyVim defaults
   - Prevents treesitter from trying to install parsers in read-only Nix store

## Adding New Plugins

### Method 1: Add Nix-Managed Plugin

For plugins available in `pkgs.vimPlugins`:

1. **Add to Nix plugin list** in `dotfiles/home-manager/nvim.nix`:
   ```nix
   plugins = with pkgs.vimPlugins; [
     # ... existing plugins
     harpoon2  # Add your plugin here
   ];
   ```

2. **Configure the plugin** in `dotfiles/config/nvim/lua/plugins/`:
   ```lua
   -- lua/plugins/harpoon.lua
   return {
     {
       "ThePrimeagen/harpoon",
       branch = "harpoon2",
       dependencies = { "nvim-lua/plenary.nvim" },
       config = function()
         -- Plugin configuration here
       end,
     },
   }
   ```

3. **Rebuild**: `sudo nixos-rebuild switch`

### Method 2: Let LazyVim Download Plugin

For plugins not in nixpkgs or for testing:

1. **Only add Lua configuration** in `dotfiles/config/nvim/lua/plugins/`:
   ```lua
   -- lua/plugins/new-plugin.lua
   return {
     {
       "author/plugin-name",
       config = function()
         -- Plugin configuration
       end,
     },
   }
   ```

2. **No rebuild needed** - LazyVim will download the plugin automatically

## Plugin Configuration vs Plugin Management

### Plugin Management (Nix Level)
- **What**: Installing/providing the plugin files
- **Where**: `dotfiles/home-manager/nvim.nix` in the `plugins` list
- **Why**: Reproducible builds, offline capability, version control
- **When to use**: For plugins you want to lock to specific versions

### Plugin Configuration (Lua Level)
- **What**: Configuring how plugins behave (settings, keymaps, etc.)
- **Where**: `dotfiles/config/nvim/lua/plugins/*.lua`
- **Why**: Standard LazyVim configuration, easy to iterate on
- **When to use**: Always - even Nix-managed plugins need Lua configuration

## Adding Language Support

### LSP Setup
1. **Add LSP to Nix packages**:
   ```nix
   extraPackages = with pkgs; [
     # ... existing packages
     typescript-language-server
   ];
   ```

2. **Configure LSP** in `lua/plugins/lsp.lua`:
   ```lua
   return {
     {
       "neovim/nvim-lspconfig",
       opts = {
         servers = {
           tsserver = {},  -- Enable TypeScript LSP
         },
       },
     },
   }
   ```

### Treesitter Parsers
Add to the parser list in `nvim.nix`:
```nix
(pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
  # ... existing parsers
  typescript
  tsx
]))
```

## Troubleshooting

### "No specs found for module plugins"
- Ensure you have at least one `.lua` file in `dotfiles/config/nvim/lua/plugins/`
- Or remove `{ import = "plugins" }` from the lazy spec if you don't have custom plugins

### Treesitter "read-only file system" errors
- Ensure treesitter opts use `function(_, opts)` pattern
- Verify `opts.ensure_installed = {}` and `opts.auto_install = false`

### Keymap "got nil" errors
- Wrap function references in `function()` to defer evaluation:
  ```lua
  -- Bad: LazyVim.some.func
  -- Good: function() LazyVim.some.func() end
  ```

### Config not loading
- Clear nvim cache: `rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim`
- Check that both `lazy.lua` and `nvim.nix` have their respective setup calls

## File Structure

```
dotfiles/
├── home-manager/
│   └── nvim.nix                 # Nix configuration (plugin management)
└── config/nvim/
    ├── README.md                # This file
    └── lua/
        ├── config/
        │   ├── lazy.lua         # Lazy.nvim bootstrap
        │   ├── keymaps.lua      # Custom keymaps
        │   ├── options.lua      # Neovim options
        │   └── autocmds.lua     # Autocommands
        └── plugins/
            ├── colorscheme.lua  # Theme configuration
            ├── lsp.lua         # LSP configuration
            └── *.lua           # Other plugin configs
```

## References

- [Original GitHub Discussion](https://github.com/LazyVim/LazyVim/discussions/1972)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)