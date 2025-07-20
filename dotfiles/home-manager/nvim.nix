{ pkgs, inputs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        
        # Line numbers
        lineNumberMode = "relNumber";
        
        # Theme (will be overridden by Stylix)
        theme = {
          enable = true;
          name = "base16";
        };

        # Status line
        statusline = {
          lualine = {
            enable = true;
          };
        };

        # File tree
        filetree = {
          nvimTree = {
            enable = true;
          };
        };

        # Dashboard
        dashboard = {
          alpha = {
            enable = true;
          };
        };

        # Terminal integration
        terminal = {
          toggleterm = {
            enable = true;
            lazygit = {
              enable = true;
            };
          };
        };

        # LSP
        lsp = {
          enable = true;
        };

        # Languages (basic enablement only)
        languages = {
          enableFormat = true;
          enableTreesitter = true;

          nix.enable = true;
          lua.enable = true;
          python.enable = true;
          rust.enable = true;
          yaml.enable = true;
          bash.enable = true;
        };

        # Completion
        autocomplete = {
          nvim-cmp = {
            enable = true;
          };
        };

        # Snippets
        snippets = {
          luasnip = {
            enable = true;
          };
        };

        # Telescope
        telescope = {
          enable = true;
        };

        # Treesitter
        treesitter = {
          enable = true;
          context = {
            enable = true;
          };
        };

        # Git
        git = {
          enable = true;
          gitsigns = {
            enable = true;
          };
        };

        # Visuals
        visuals = {
          nvim-web-devicons = {
            enable = true;
          };
        };

        # Comments
        comments = {
          comment-nvim = {
            enable = true;
          };
        };

        # Autopairs
        autopairs = {
          nvim-autopairs = {
            enable = true;
          };
        };

        # Key mappings
        maps = {
          normal = {
            "<leader>e" = {
              action = ":NvimTreeToggle<CR>";
              desc = "Toggle file tree";
            };
            "<leader>ff" = {
              action = ":Telescope find_files<CR>";
              desc = "Find files";
            };
            "<leader>fw" = {
              action = ":Telescope live_grep<CR>";
              desc = "Live grep";
            };
            "<leader>fb" = {
              action = ":Telescope buffers<CR>";
              desc = "Find buffers";
            };
            "<leader>gd" = {
              action = ":lua vim.lsp.buf.definition()<CR>";
              desc = "Go to definition";
            };
            "<leader>gr" = {
              action = ":lua vim.lsp.buf.references()<CR>";
              desc = "Find references";
            };
            "<leader>k" = {
              action = ":lua vim.lsp.buf.hover()<CR>";
              desc = "Show hover documentation";
            };
            "<leader>ga" = {
              action = ":lua vim.lsp.buf.code_action()<CR>";
              desc = "Code actions";
            };
            "<leader>rn" = {
              action = ":lua vim.lsp.buf.rename()<CR>";
              desc = "Rename symbol";
            };
            "<leader>gg" = {
              action = ":lua vim.lsp.buf.format()<CR>";
              desc = "Format buffer";
            };
            "<leader>lg" = {
              action = ":ToggleTerm<CR>lazygit<CR>";
              desc = "LazyGit";
            };
            "[d" = {
              action = ":lua vim.diagnostic.goto_prev()<CR>";
              desc = "Previous diagnostic";
            };
            "]d" = {
              action = ":lua vim.diagnostic.goto_next()<CR>";
              desc = "Next diagnostic";
            };
          };
          visual = {
            "<leader>y" = {
              action = "\"+y";
              desc = "Yank to system clipboard";
            };
          };
        };
      };
    };
  };
}