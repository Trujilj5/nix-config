# NVF Neovim Configuration - Declarative Neovim setup using nvf
# This configuration migrates from Lazy.nvim to a fully declarative NixOS approach
# All plugins and configurations are now managed through nvf for better reproducibility

{ pkgs, inputs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # Basic editor setup
        viAlias = true;
        vimAlias = true;
        
        # Core editor settings
        lineNumberMode = "relNumber";  # Show relative line numbers
        syntaxHighlighting = true;
        
        # Editor behavior and appearance options
        options = {
          # Indentation
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          autoindent = true;
          
          # Navigation and display
          scrolloff = 8;
          wrap = false;
          
          # Search behavior
          ignorecase = true;
          smartcase = true;
          hlsearch = false;
          incsearch = true;
          
          # Performance and UI
          updatetime = 50;
          signcolumn = "yes";
          termguicolors = true;
        };
        
        # Leader key configuration
        globals.mapleader = " ";        # Space as leader key
        globals.maplocalleader = " ";   # Space as local leader key
        
        # Theme configuration (integrates with Stylix theming)
        theme = {
          enable = true;
          name = "base16";  # Compatible with Stylix base16 themes
        };

        # Status line configuration
        statusline = {
          lualine = {
            enable = true;  # Modern statusline with git integration
          };
        };

        # Buffer tabline (replaces barbar from original config)
        tabline = {
          nvimBufferline = {
            enable = true;  # Shows open buffers as tabs
          };
        };

        # File explorer (replaces neo-tree from original config)
        filetree = {
          nvimTree = {
            enable = true;  # File tree sidebar
          };
        };

        # Start screen dashboard
        dashboard = {
          alpha = {
            enable = true;  # Welcome screen with shortcuts
          };
        };

        # Terminal integration with LazyGit
        terminal = {
          toggleterm = {
            enable = true;
            lazygit = {
              enable = true;  # LazyGit integration through toggleterm
            };
          };
        };

        # Language Server Protocol configuration
        lsp = {
          enable = true;  # Enables LSP support for all configured languages
        };

        # Language support configuration
        languages = {
          enableFormat = true;      # Auto-formatting support
          enableTreesitter = true;  # Syntax highlighting and parsing
          
          # Enabled languages with LSP support
          nix.enable = true;     # Nix language support
          lua.enable = true;     # Lua language support  
          python.enable = true;  # Python language support
          rust.enable = true;    # Rust language support
          yaml.enable = true;    # YAML language support
          bash.enable = true;    # Bash language support
        };

        # Auto-completion system
        autocomplete = {
          nvim-cmp = {
            enable = true;  # Modern completion engine
          };
        };

        # Code snippets
        snippets = {
          luasnip = {
            enable = true;  # Snippet engine for code templates
          };
        };

        # Fuzzy finder and file navigation
        telescope = {
          enable = true;  # Powerful fuzzy finder for files, buffers, etc.
        };

        # Advanced syntax highlighting and parsing
        treesitter = {
          enable = true;
          context = {
            enable = true;  # Shows current context (function, class, etc.)
          };
        };

        # Git integration
        git = {
          enable = true;
          gitsigns = {
            enable = true;  # Shows git changes in gutter
          };
        };

        # Visual enhancements
        visuals = {
          nvim-web-devicons = {
            enable = true;  # File type icons
          };
          indent-blankline = {
            enable = true;  # Indentation guides
          };
        };

        # Code commenting
        comments = {
          comment-nvim = {
            enable = true;  # Smart commenting with language-aware support
          };
        };

        # Automatic bracket/quote pairing
        autopairs = {
          nvim-autopairs = {
            enable = true;  # Auto-closes brackets, quotes, etc.
          };
        };

        # Keybinding discovery and hints
        binds = {
          whichKey = {
            enable = true;  # Shows available keybindings when you pause
          };
        };

        # Custom keybinding mappings
        # All keybindings use Space as the leader key
        maps = {
          normal = {
            # File explorer controls
            "<leader>e" = {
              action = ":NvimTreeToggle<CR>";
              desc = "Toggle file tree";
            };
            "<leader>c" = {
              action = ":NvimTreeClose<CR>";
              desc = "Close file tree";
            };
            
            # File and text search (Telescope)
            "<leader>ff" = {
              action = ":Telescope find_files<CR>";
              desc = "Find files";
            };
            "<leader>fw" = {
              action = ":Telescope live_grep<CR>";
              desc = "Search text in files";
            };
            "<leader>fb" = {
              action = ":Telescope buffers<CR>";
              desc = "Find open buffers";
            };
            "<leader>fh" = {
              action = ":Telescope help_tags<CR>";
              desc = "Search help documentation";
            };
            
            # Language Server Protocol actions
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
              desc = "Show documentation";
            };
            "<leader>ga" = {
              action = ":lua vim.lsp.buf.code_action()<CR>";
              desc = "Show code actions";
            };
            "<leader>rn" = {
              action = ":lua vim.lsp.buf.rename()<CR>";
              desc = "Rename symbol";
            };
            "<leader>gf" = {
              action = ":lua vim.lsp.buf.format()<CR>";
              desc = "Format code";
            };
            
            # Git operations
            "<leader>lg" = {
              action = ":ToggleTerm<CR>lazygit<CR>";
              desc = "Open LazyGit";
            };
            "<leader>gs" = {
              action = ":Telescope git_status<CR>";
              desc = "Show git status";
            };
            
            # Buffer management (replaces barbar functionality)
            "<leader>n" = {
              action = ":BufferLineCycleNext<CR>";
              desc = "Next buffer";
            };
            "<leader>p" = {
              action = ":BufferLineCyclePrev<CR>";
              desc = "Previous buffer";
            };
            "<leader>x" = {
              action = ":bdelete<CR>";
              desc = "Close current buffer";
            };
            "<leader>1" = {
              action = ":BufferLineGoToBuffer 1<CR>";
              desc = "Go to buffer 1";
            };
            "<leader>2" = {
              action = ":BufferLineGoToBuffer 2<CR>";
              desc = "Go to buffer 2";
            };
            "<leader>3" = {
              action = ":BufferLineGoToBuffer 3<CR>";
              desc = "Go to buffer 3";
            };
            "<leader>4" = {
              action = ":BufferLineGoToBuffer 4<CR>";
              desc = "Go to buffer 4";
            };
            "<leader>5" = {
              action = ":BufferLineGoToBuffer 5<CR>";
              desc = "Go to buffer 5";
            };
            
            # Enhanced navigation (centers cursor after movement)
            "<C-d>" = {
              action = "<C-d>zz";
              desc = "Scroll down and center cursor";
            };
            "<C-u>" = {
              action = "<C-u>zz";
              desc = "Scroll up and center cursor";
            };
            "n" = {
              action = "nzzzv";
              desc = "Next search result (centered)";
            };
            "N" = {
              action = "Nzzzv";
              desc = "Previous search result (centered)";
            };
            
            # System clipboard integration
            "<leader>y" = {
              action = "\"+y";
              desc = "Copy to system clipboard";
            };
            
            # Error and warning navigation
            "[d" = {
              action = ":lua vim.diagnostic.goto_prev()<CR>";
              desc = "Previous diagnostic/error";
            };
            "]d" = {
              action = ":lua vim.diagnostic.goto_next()<CR>";
              desc = "Next diagnostic/error";
            };
            "<leader>q" = {
              action = ":lua vim.diagnostic.setloclist()<CR>";
              desc = "List all diagnostics";
            };
            
            # Clear search highlighting
            "<Esc>" = {
              action = ":nohlsearch<CR>";
              desc = "Clear search highlighting";
            };
            
            # Help and discovery
            "<leader>?" = {
              action = ":WhichKey<CR>";
              desc = "Show all keybindings";
            };
            
            # Terminal access
            "<leader>t" = {
              action = ":ToggleTerm<CR>";
              desc = "Toggle floating terminal";
            };
            
            # Quick indentation
            "<Tab>" = {
              action = ">>";
              desc = "Indent current line";
            };
            "<S-Tab>" = {
              action = "<<";
              desc = "Outdent current line";
            };
          };
          
          # Visual mode mappings
          visual = {
            "<leader>y" = {
              action = "\"+y";
              desc = "Copy selection to system clipboard";
            };
            # Maintain selection while indenting
            "<Tab>" = {
              action = ">gv";
              desc = "Indent selection (keep selected)";
            };
            "<S-Tab>" = {
              action = "<gv";
              desc = "Outdent selection (keep selected)";
            };
          };
          
          # Insert mode mappings
          insert = {
            # Quick escape from insert mode
            "jk" = {
              action = "<Esc>";
              desc = "Exit insert mode (alternative to Esc)";
            };
          };
        };

      };
    };
  };
}

# Configuration Summary:
# - Migrated from Lazy.nvim to declarative nvf configuration
# - All Lua plugins converted to Nix-managed equivalents
# - LazyGit integration through toggleterm 
# - Full LSP support for multiple languages
# - Telescope for fuzzy finding
# - TreeSitter for syntax highlighting
# - Git integration with gitsigns
# - Buffer management with nvim-bufferline
# - File explorer with nvim-tree
# - Which-key for keybinding discovery
# - Compatible with Stylix theming system