# Based on https://github.com/LazyVim/LazyVim/discussions/1972
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # LazyVim dependencies
      lua-language-server
      stylua
      # Telescope
      ripgrep
      fd
      # Git
      lazygit
      # Language servers and formatters
      nil # Nix LSP
      nixd # Alternative Nix LSP
      bash-language-server
      pyright
      rust-analyzer
      typescript-language-server
      vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      tailwindcss-language-server
      # General tools
      gcc
      nodejs
      unzip
      git
      # AI tools
      copilot-language-server
      # PHP
      intelephense
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          # LazyVim core
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          undotree
          vim-illuminate
          vim-startuptime
          which-key-nvim
          nvim-scrollbar
          nvim-hlslens
          nvim-ufo
          promise-async
          { name = "LuaSnip"; path = luasnip; }
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.bufremove"; path = mini-nvim; }
          { name = "mini.comment"; path = mini-nvim; }
          { name = "mini.indentscope"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.surround"; path = mini-nvim; }
        ];
        mkEntryFromDrv = drv:
          if pkgs.lib.isDerivation drv then
            { name = "${pkgs.lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        -- Disable helptags generation to prevent write errors in read-only Nix store
        -- Override vim.api.nvim_cmd to intercept helptags commands
        local original_nvim_cmd = vim.api.nvim_cmd
        vim.api.nvim_cmd = function(cmd, opts)
          if cmd.cmd == "helptags" then
            return ""
          end
          return original_nvim_cmd(cmd, opts)
        end

        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          install = {
            missing = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = true,
          },
          performance = {
            rtp = {
              disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
          change_detection = {
            -- Disable change detection to avoid read-only Nix store errors
            enabled = false,
          },
          pkg = {
            enabled = false,
          },
          rocks = {
            enabled = false,
          },
          readme = {
            enabled = false,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            -- import/override with your plugins
            { import = "plugins" },
            -- treesitter handled by nix, clear ensure_installed to prevent conflicts
            { "nvim-treesitter/nvim-treesitter",
              opts = function(_, opts)
                opts.ensure_installed = {}
                opts.auto_install = false
                opts.highlight = { enable = true }
                opts.indent = { enable = true }
                opts.incremental_selection = { enable = true }
                return opts
              end,
            },
          },
        })
      '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          bash
          c
          lua
          markdown
          nix
          python
          rust
          vim
          vimdoc
          # Ionite project parsers
          typescript
          tsx
          javascript
          json
          css
          html
          sql
          php
        ])).dependencies;
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ../../dotfiles/config/nvim/lua;
}
