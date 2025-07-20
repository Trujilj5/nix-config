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
      -- Basic editor settings
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.wrap = false
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      vim.opt.scrolloff = 8
      vim.opt.updatetime = 50

      -- Leader key
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Basic keymaps
      vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent line" })
      vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent line" })
      vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selected lines" })
      vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent selected lines" })

      -- Movement and navigation
      vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
      vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
      vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
      vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

      -- System clipboard
      vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
      vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })

      -- Clear search highlighting
      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

      -- LSP Keybinds (configured when LSP attaches)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover documentation" }))
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
          vim.keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
          vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
        end,
      })

      -- Diagnostic keymaps
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

      -- Prevent treesitter from trying to install parsers in Nix store
      vim.env.CC = ""
      vim.g.loaded_tree_sitter_install = 1

      -- Setup Lazy.nvim
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

      -- Load plugins
      require("lazy").setup({
        -- Dashboard
        {
          "goolord/alpha-nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
              [[  ███       ███  ]],
              [[  ████      ████ ]],
              [[  ████     █████ ]],
              [[ █ ████    █████ ]],
              [[ ██ ████   █████ ]],
              [[ ███ ████  █████ ]],
              [[ ████ ████ ████ ]],
              [[ █████  ████████ ]],
              [[ █████   ███████ ]],
              [[ █████    ██████ ]],
              [[ █████     █████ ]],
              [[ ████      ████ ]],
              [[  ███       ███  ]],
              [[                    ]],
              [[  N  E  O  V  I  M  ]],
            }
            require("alpha").setup(dashboard.opts)
          end,
        },

        -- Buffer tabs
        {
          "romgrk/barbar.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            vim.g.barbar_auto_setup = false
            require("barbar").setup({
              animation = true,
              auto_hide = false,
              clickable = true,
              icons = {
                buffer_index = false,
                filetype = { enabled = true },
                separator = { left = "▎", right = "" },
              },
            })
            
            -- Buffer navigation keymaps
            vim.keymap.set("n", "<leader>n", "<Cmd>BufferNext<CR>", { desc = "Go to next buffer" })
            vim.keymap.set("n", "<leader>p", "<Cmd>BufferPrevious<CR>", { desc = "Go to previous buffer" })
            vim.keymap.set("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", { desc = "Go to buffer 1" })
            vim.keymap.set("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", { desc = "Go to buffer 2" })
            vim.keymap.set("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", { desc = "Go to buffer 3" })
            vim.keymap.set("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", { desc = "Go to buffer 4" })
            vim.keymap.set("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", { desc = "Go to buffer 5" })
            vim.keymap.set("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", { desc = "Go to buffer 6" })
            vim.keymap.set("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", { desc = "Go to buffer 7" })
            vim.keymap.set("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", { desc = "Go to buffer 8" })
            vim.keymap.set("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", { desc = "Go to buffer 9" })
            vim.keymap.set("n", "<leader>0", "<Cmd>BufferLast<CR>", { desc = "Go to last buffer" })
            vim.keymap.set("n", "<leader>x", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
          end,
        },

        -- File explorer
        {
          "nvim-neo-tree/neo-tree.nvim",
          branch = "v3.x",
          dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
          },
          config = function()
            require("neo-tree").setup({
              filesystem = {
                filtered_items = {
                  visible = true,
                  hide_dotfiles = false,
                  hide_gitignored = false,
                },
              },
            })
            
            -- Neotree keymaps
            vim.keymap.set("n", "<leader>e", ":Neotree<CR>", { desc = "Open Neotree" })
            vim.keymap.set("n", "<leader>c", ":Neotree action=close<CR>", { desc = "Close Neotree" })
            vim.keymap.set("n", "<leader>gs", ":Neotree float git_status<CR>", { desc = "Show Git status in Neotree" })
          end,
        },

        -- Git integration
        {
          "kdheepak/lazygit.nvim",
          cmd = { "LazyGit" },
          dependencies = { "nvim-lua/plenary.nvim" },
          keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
          },
        },

        -- Git signs
        {
          "lewis6991/gitsigns.nvim",
          config = function()
            require("gitsigns").setup()
          end,
        },

        -- Key binding help
        {
          "folke/which-key.nvim",
          config = function()
            local wk = require("which-key")
            wk.setup({})
            vim.keymap.set("n", "<leader>?", function()
              wk.show({ global = false })
            end, { desc = "Buffer Local Keymaps (which-key)" })
          end,
        },

        -- Fallback colorscheme
        {
          "catppuccin/nvim",
          name = "catppuccin",
          priority = 1000,
          config = function()
            -- Only set colorscheme if Stylix hasn't already set one
            if not vim.g.colors_name then
              vim.cmd.colorscheme "catppuccin"
            end
          end,
        },

        install = { colorscheme = { "catppuccin" } },
        checker = { enabled = false },
      })

      -- Configure treesitter after plugins are loaded
      vim.schedule(function()
        if pcall(require, "nvim-treesitter.configs") then
          -- Disable all installation attempts
          local install = require("nvim-treesitter.install")
          install.prefer_git = false
          install.compilers = {}
          
          require("nvim-treesitter.configs").setup({
            auto_install = false,
            sync_install = false,
            ensure_installed = {},
            ignore_install = { "all" },
            highlight = { enable = true },
            indent = { enable = true },
            modules = {},
          })
        end
      end)
    '';

    # All plugins managed by Nix for reproducibility
    plugins = with pkgs.vimPlugins; [
      # LSP Configuration
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
          local lspconfig = require("lspconfig")
          
          -- Lua LSP
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              },
            },
          })

          -- TypeScript/JavaScript LSP
          lspconfig.ts_ls.setup({
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
            single_file_support = true,
          })

          -- Nix LSP
          lspconfig.nil_ls.setup({})

          -- Java LSP
          lspconfig.jdtls.setup({
            cmd = { "jdt-language-server", "-data", vim.fn.expand("~/.cache/jdtls") },
            root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git"),
          })

          -- YAML LSP
          lspconfig.yamlls.setup({
            settings = {
              yaml = {
                schemas = {
                  ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
                  ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                },
              },
            },
          })

          -- Bash LSP
          lspconfig.bashls.setup({})

          -- Python LSP
          lspconfig.pylsp.setup({})

          -- Rust LSP
          lspconfig.rust_analyzer.setup({})
          EOF
        '';
      }

      # Completion
      {
        plugin = nvim-cmp;
        config = ''
          lua << EOF
          vim.opt.completeopt = "menu,menuone,noselect"
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          require("luasnip.loaders.from_vscode").lazy_load()

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "path" },
            }, {
              { name = "buffer" },
            }),
          })
          EOF
        '';
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets

      # Telescope
      {
        plugin = telescope-nvim;
        config = ''
          lua << EOF
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
          vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = 'Telescope live grep' })
          vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
          
          require('telescope').setup({
            extensions = {
              ['ui-select'] = {
                require('telescope.themes').get_dropdown {}
              }
            }
          })
          require('telescope').load_extension('ui-select')
          EOF
        '';
      }
      telescope-ui-select-nvim
      plenary-nvim

      # Treesitter
      nvim-treesitter.withAllGrammars

      # Formatting
      {
        plugin = conform-nvim;
        config = ''
          lua << EOF
          require("conform").setup({
            formatters_by_ft = {
              lua = { "stylua" },
              javascript = { "biome", "prettier" },
              typescript = { "biome", "prettier" },
              json = { "prettier" },
              yaml = { "prettier" },
              nix = { "nixpkgs_fmt" },
              python = { "black" },
              rust = { "rustfmt" },
            },
            format_on_save = false,
          })
          
          vim.keymap.set("n", "<leader>gg", function()
            require("conform").format({ bufnr = vim.api.nvim_get_current_buf(), lsp_fallback = true })
          end, { desc = "Format file with conform" })
          EOF
        '';
      }


      # Status line
      {
        plugin = lualine-nvim;
        config = ''
          lua << EOF
          require("lualine").setup({
            options = {
              theme = "auto",
            },
          })
          EOF
        '';
      }
      nvim-web-devicons

      # Base16 colorscheme (managed by Stylix)
      base16-nvim
    ];

    # LSP servers and tools managed by Nix
    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server
      nil
      nixd
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      python3Packages.python-lsp-server
      rust-analyzer
      jdt-language-server
      yaml-language-server
      
      # Formatters
      stylua
      nixpkgs-fmt
      nodePackages.prettier
      biome
      black
      rustfmt
      
      # Development tools
      ripgrep
      fd
      git
      lazygit
      tree-sitter
      
      # Build tools
      gcc
      gnumake
      cmake
      pkg-config
      unzip
    ];
  };

  home.file = {
    ".config/nvim/.luarc.json".source = ../config/nvim/.luarc.json;
  };
}