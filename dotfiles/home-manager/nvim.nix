{ pkgs, ... }:

{
  stylix.targets.neovim = {
    enable = true;
    plugin = "base16-nvim";
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      require("vim-options")
      -- Only load Lazy.nvim for complex plugins that aren't managed by Nix
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)
      
      -- Load only plugins not managed by Nix
      require("lazy").setup({
        spec = {
          { import = "plugins.alpha" },        -- Complex dashboard
          { import = "plugins.buffer-tabs" },  -- Complex buffer management
          { import = "plugins.lazy-git" },     -- Git integration
          { import = "plugins.neotree" },      -- File explorer
          { import = "plugins.which-key" },    -- Key binding helper
          { import = "plugins.catppuccin" },   -- Fallback colorscheme
        },
        install = { colorscheme = { "catppuccin" } },
        checker = { enabled = false }, -- Disable since we manage versions with Nix
      })
    '';

    # Core plugins managed by Nix for better reproducibility
    plugins = with pkgs.vimPlugins; [
      # LSP and completion
      {
        plugin = nvim-lspconfig;
        config = "lua require('plugins.lsp-config')";
      }
      {
        plugin = nvim-cmp;
        config = "lua require('plugins.nvim-cmp')";
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # Telescope for fuzzy finding
      {
        plugin = telescope-nvim;
        config = "lua require('plugins.telescope')";
      }
      telescope-ui-select-nvim
      plenary-nvim
      
      # Treesitter for syntax highlighting
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = "lua require('plugins.treesitter')";
      }
      
      # Formatting
      {
        plugin = conform-nvim;
        config = "lua require('plugins.conform')";
      }
      
      # Base16 colorscheme (managed by Stylix)
      base16-nvim
      
      # Git integration
      {
        plugin = gitsigns-nvim;
        config = "lua require('gitsigns').setup()";
      }
      
      # Status line
      {
        plugin = lualine-nvim;
        config = "lua require('plugins.lualine')";
      }
      nvim-web-devicons
    ];

    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server        # Lua
      nil                        # Nix
      nixd                       # Alternative Nix LSP
      nodePackages.typescript-language-server  # TypeScript/JavaScript
      nodePackages.bash-language-server        # Bash
      python3Packages.python-lsp-server        # Python
      rust-analyzer              # Rust
      jdt-language-server        # Java
      yaml-language-server       # YAML
      
      # Formatters
      stylua                     # Lua formatter
      nixpkgs-fmt               # Nix formatter
      nodePackages.prettier     # JS/TS/JSON formatter
      biome                     # Fast JS/TS formatter (alternative)
      black                     # Python formatter
      rustfmt                   # Rust formatter
      
      # Development tools
      ripgrep                   # Fast grep for Telescope
      fd                        # Fast find alternative
      git                       # Git integration
      lazygit                   # Git TUI
      tree-sitter               # Syntax highlighting
      
      # Build tools for native compilation
      gcc
      gnumake
      cmake
      pkg-config
      unzip                     # For some plugin installations
    ];
  };

  home.file = {
    # Only copy Lazy.nvim managed plugins and vim-options
    ".config/nvim/lua/vim-options.lua".source = ../config/nvim/lua/vim-options.lua;
    ".config/nvim/lua/plugins/alpha.lua".source = ../config/nvim/lua/plugins/alpha.lua;
    ".config/nvim/lua/plugins/buffer-tabs.lua".source = ../config/nvim/lua/plugins/buffer-tabs.lua;
    ".config/nvim/lua/plugins/lazy-git.lua".source = ../config/nvim/lua/plugins/lazy-git.lua;
    ".config/nvim/lua/plugins/neotree.lua".source = ../config/nvim/lua/plugins/neotree.lua;
    ".config/nvim/lua/plugins/which-key.lua".source = ../config/nvim/lua/plugins/which-key.lua;
    ".config/nvim/lua/plugins/catppuccin.lua".source = ../config/nvim/lua/plugins/catppuccin.lua;

    ".config/nvim/lazy-lock.json".source = ../config/nvim/lazy-lock.json;
    ".config/nvim/.luarc.json".source = ../config/nvim/.luarc.json;
  };
}