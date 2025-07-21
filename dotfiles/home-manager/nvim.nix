# NVF Neovim Configuration
# Modular configuration organized into logical sections for maintainability
#
# MODULES:
# - Core Config: Basic editor settings, options, theme, and leader keys
# - UI Config: Status line, tabs, file explorer, dashboard, and visual elements  
# - Development Config: LSP, languages, completion, snippets, and code editing
# - Navigation Config: Telescope, git integration, and terminal functionality
# - Keybindings Config: All keyboard shortcuts organized by functionality
#
# MIGRATION STATUS: ✅ Complete - All Lua plugins converted to nvf equivalents
{ lib, ... }:

let
  #═══════════════════════════════════════════════════════════════════════════════
  # CORE EDITOR CONFIGURATION
  #═══════════════════════════════════════════════════════════════════════════════
  coreConfig = {
    # Basic editor setup
    viAlias = true;
    vimAlias = true;
    lineNumberMode = "relNumber";
    syntaxHighlighting = true;
    
    # Editor behavior and appearance
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
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    
    # Theme integration with Stylix
    theme = {
      enable = true;
      name = "base16";
    };
  };

  #═══════════════════════════════════════════════════════════════════════════════
  # USER INTERFACE COMPONENTS
  #═══════════════════════════════════════════════════════════════════════════════
  uiConfig = {
    # Status line
    statusline = {
      lualine = {
        enable = true;
      };
    };
    
    # Buffer tabs (replaces barbar)
    tabline = {
      nvimBufferline = {
        enable = true;
      };
    };
    
    # File explorer (replaces neo-tree)
    filetree = {
      nvimTree = {
        enable = true;
      };
    };
    
    # Start screen dashboard
    dashboard = {
      alpha = {
        enable = true;
      };
    };
    
    # Visual enhancements
    visuals = {
      nvim-web-devicons = {
        enable = true;
      };
      indent-blankline = {
        enable = true;
      };
    };
    
    # Keybinding discovery
    binds = {
      whichKey = {
        enable = true;
      };
    };
  };

  #═══════════════════════════════════════════════════════════════════════════════
  # DEVELOPMENT TOOLS
  #═══════════════════════════════════════════════════════════════════════════════
  developmentConfig = {
    # Language Server Protocol
    lsp = {
      enable = true;
    };
    
    # Language support
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      
      # Supported languages
      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      rust.enable = true;
      yaml.enable = true;
      bash.enable = true;
    };
    
    # Auto-completion
    autocomplete = {
      nvim-cmp = {
        enable = true;
      };
    };
    
    # Code snippets
    snippets = {
      luasnip = {
        enable = true;
      };
    };
    
    # Syntax highlighting and parsing
    treesitter = {
      enable = true;
      context = {
        enable = true;
      };
    };
    
    # Code editing helpers
    comments = {
      comment-nvim = {
        enable = true;
      };
    };
    
    autopairs = {
      nvim-autopairs = {
        enable = true;
      };
    };
  };

  #═══════════════════════════════════════════════════════════════════════════════
  # NAVIGATION AND SEARCH
  #═══════════════════════════════════════════════════════════════════════════════
  navigationConfig = {
    # Fuzzy finder
    telescope = {
      enable = true;
    };
    
    # Git integration
    git = {
      enable = true;
      gitsigns = {
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
  };

  #═══════════════════════════════════════════════════════════════════════════════
  # KEYBINDINGS AND SHORTCUTS
  #═══════════════════════════════════════════════════════════════════════════════
  keybindingsConfig = {
    maps = {
      normal = {
        # ─── File Explorer ───
        "<leader>e" = {
          action = ":NvimTreeToggle<CR>";
          desc = "Toggle file tree";
        };
        "<leader>c" = {
          action = ":NvimTreeClose<CR>";
          desc = "Close file tree";
        };
        
        # ─── File and Text Search ───
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
        
        # ─── LSP Actions ───
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
        
        # ─── Git Operations ───
        "<leader>lg" = {
          action = ":ToggleTerm<CR>lazygit<CR>";
          desc = "Open LazyGit";
        };
        "<leader>gs" = {
          action = ":Telescope git_status<CR>";
          desc = "Show git status";
        };
        
        # ─── Buffer Management ───
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
        
        # ─── Enhanced Navigation ───
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
        
        # ─── System Integration ───
        "<leader>y" = {
          action = "\"+y";
          desc = "Copy to system clipboard";
        };
        
        # ─── Diagnostics and Errors ───
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
        
        # ─── Utility Commands ───
        "<Esc>" = {
          action = ":nohlsearch<CR>";
          desc = "Clear search highlighting";
        };
        "<leader>?" = {
          action = ":WhichKey<CR>";
          desc = "Show all keybindings";
        };
        "<leader>t" = {
          action = ":ToggleTerm<CR>";
          desc = "Toggle floating terminal";
        };
        
        # ─── Quick Indentation ───
        "<Tab>" = {
          action = ">>";
          desc = "Indent current line";
        };
        "<S-Tab>" = {
          action = "<<";
          desc = "Outdent current line";
        };
      };
      
      # ─── Visual Mode Mappings ───
      visual = {
        "<leader>y" = {
          action = "\"+y";
          desc = "Copy selection to system clipboard";
        };
        "<Tab>" = {
          action = ">gv";
          desc = "Indent selection (keep selected)";
        };
        "<S-Tab>" = {
          action = "<gv";
          desc = "Outdent selection (keep selected)";
        };
      };
      
      # ─── Insert Mode Mappings ───
      insert = {
        "jk" = {
          action = "<Esc>";
          desc = "Exit insert mode (alternative to Esc)";
        };
      };
    };
  };

  #═══════════════════════════════════════════════════════════════════════════════
  # CONFIGURATION ASSEMBLY
  #═══════════════════════════════════════════════════════════════════════════════
  
  # Merge all configuration modules into a single vim configuration
  vimConfig = lib.recursiveUpdate
    (lib.recursiveUpdate
      (lib.recursiveUpdate
        (lib.recursiveUpdate coreConfig uiConfig)
        developmentConfig)
      navigationConfig)
    keybindingsConfig;

in
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = vimConfig;
    };
  };
}
