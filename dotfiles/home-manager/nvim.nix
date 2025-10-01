# LazyVim-inspired NVF Configuration
# Recreating LazyVim's functionality and keybindings using nvf
{ lib, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        # Core Settings (LazyVim defaults)
        viAlias = true;
        vimAlias = true;
        lineNumberMode = "relNumber";
        syntaxHighlighting = true;

        # Leader Keys (LazyVim style)
        globals = {
          mapleader = " ";
          maplocalleader = "\\";
        };

        # Editor Options (LazyVim defaults)
        options = {
          # Indentation
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          autoindent = true;
          smartindent = true;

          # Search
          ignorecase = true;
          smartcase = true;
          hlsearch = false;
          incsearch = true;

          # UI
          number = true;
          relativenumber = true;
          signcolumn = "yes";
          wrap = false;
          scrolloff = 4;
          sidescrolloff = 8;

          # Performance
          updatetime = 200;
          timeoutlen = 300;

          # Splits
          splitright = true;
          splitbelow = true;

          # Other
          termguicolors = true;
          mouse = "a";
          clipboard = "unnamedplus";
          conceallevel = 2;
          pumheight = 10;
        };

        # Theme (using existing base16 theme)
        theme = {
          enable = true;
          name = lib.mkForce "base16";
        };

        # UI Components
        statusline = {
          lualine = {
            enable = true;
            theme = lib.mkForce "auto";
          };
        };

        tabline = {
          nvimBufferline = {
            enable = true;
          };
        };

        dashboard = {
          alpha = {
            enable = true;
          };
        };

        filetree = {
          nvimTree = {
            enable = true;
          };
        };

        # Visual Enhancements
        visuals = {
          nvim-web-devicons = {
            enable = true;
          };
          indent-blankline = {
            enable = true;
          };
        };

        # Which Key (LazyVim feature)
        binds = {
          whichKey = {
            enable = true;
          };
        };

        # Telescope (LazyVim's fuzzy finder)
        telescope = {
          enable = true;
        };

        # Treesitter (LazyVim default)
        treesitter = {
          enable = true;
          context = {
            enable = true;
          };
        };

        # LSP Configuration (LazyVim style)
        lsp = {
          enable = true;
          formatOnSave = false; # LazyVim uses conform.nvim for formatting
          lspkind = {
            enable = true;
          };
        };

        # Languages (simplified to core supported languages)
        languages = {
          enableFormat = true;
          enableTreesitter = true;

          # Core languages
          nix.enable = true;
          lua.enable = true;
          python.enable = true;
          rust.enable = true;
          bash.enable = true;
        };

        # Autocompletion (LazyVim uses nvim-cmp)
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

        # Git Integration
        git = {
          enable = true;
          gitsigns = {
            enable = true;
          };
        };

        # Comments
        comments = {
          comment-nvim = {
            enable = true;
          };
        };

        # Auto Pairs
        autopairs = {
          nvim-autopairs = {
            enable = true;
          };
        };

        # Terminal
        terminal = {
          toggleterm = {
            enable = true;
            lazygit = {
              enable = true;
            };
          };
        };

        # LazyVim Keymaps
        maps = {
          normal = {
            # File operations (LazyVim style)
            "<leader><space>" = {
              action = ":Telescope find_files<CR>";
              desc = "Find Files (Root Dir)";
            };
            "<leader>," = {
              action = ":Telescope buffers<CR>";
              desc = "Switch Buffer";
            };
            "<leader>/" = {
              action = ":Telescope live_grep<CR>";
              desc = "Grep (Root Dir)";
            };
            "<leader>:" = {
              action = ":Telescope command_history<CR>";
              desc = "Command History";
            };

            # File Explorer
            "<leader>e" = {
              action = ":NvimTreeToggle<CR>";
              desc = "Explorer NvimTree (Root Dir)";
            };
            "<leader>E" = {
              action = ":NvimTreeFocus<CR>";
              desc = "Explorer NvimTree (cwd)";
            };

            # Find operations
            "<leader>fb" = {
              action = ":Telescope buffers<CR>";
              desc = "Buffers";
            };
            "<leader>ff" = {
              action = ":Telescope find_files<CR>";
              desc = "Find Files (Root Dir)";
            };
            "<leader>fF" = {
              action = ":Telescope find_files cwd=false<CR>";
              desc = "Find Files (cwd)";
            };
            "<leader>fg" = {
              action = ":Telescope git_files<CR>";
              desc = "Find Files (git-files)";
            };
            "<leader>fr" = {
              action = ":Telescope oldfiles<CR>";
              desc = "Recent";
            };
            "<leader>fR" = {
              action = ":Telescope oldfiles cwd_only=true<CR>";
              desc = "Recent (cwd)";
            };

            # Search operations
            "<leader>sa" = {
              action = ":Telescope autocommands<CR>";
              desc = "Auto Commands";
            };
            "<leader>sb" = {
              action = ":Telescope current_buffer_fuzzy_find<CR>";
              desc = "Buffer";
            };
            "<leader>sc" = {
              action = ":Telescope command_history<CR>";
              desc = "Command History";
            };
            "<leader>sC" = {
              action = ":Telescope commands<CR>";
              desc = "Commands";
            };
            "<leader>sd" = {
              action = ":Telescope diagnostics bufnr=0<CR>";
              desc = "Document Diagnostics";
            };
            "<leader>sD" = {
              action = ":Telescope diagnostics<CR>";
              desc = "Workspace Diagnostics";
            };
            "<leader>sg" = {
              action = ":Telescope live_grep<CR>";
              desc = "Grep (Root Dir)";
            };
            "<leader>sG" = {
              action = ":Telescope live_grep cwd=false<CR>";
              desc = "Grep (cwd)";
            };
            "<leader>sh" = {
              action = ":Telescope help_tags<CR>";
              desc = "Help Pages";
            };
            "<leader>sH" = {
              action = ":Telescope highlights<CR>";
              desc = "Search Highlight Groups";
            };
            "<leader>sj" = {
              action = ":Telescope jumplist<CR>";
              desc = "Jumplist";
            };
            "<leader>sk" = {
              action = ":Telescope keymaps<CR>";
              desc = "Key Maps";
            };
            "<leader>sl" = {
              action = ":Telescope loclist<CR>";
              desc = "Location List";
            };
            "<leader>sM" = {
              action = ":Telescope man_pages<CR>";
              desc = "Man Pages";
            };
            "<leader>sm" = {
              action = ":Telescope marks<CR>";
              desc = "Jump to Mark";
            };
            "<leader>so" = {
              action = ":Telescope vim_options<CR>";
              desc = "Options";
            };
            "<leader>sR" = {
              action = ":Telescope resume<CR>";
              desc = "Resume";
            };
            "<leader>sq" = {
              action = ":Telescope quickfix<CR>";
              desc = "Quickfix List";
            };
            "<leader>sw" = {
              action = ":Telescope grep_string word_match=-w<CR>";
              desc = "Word (Root Dir)";
            };
            "<leader>sW" = {
              action = ":Telescope grep_string cwd=false word_match=-w<CR>";
              desc = "Word (cwd)";
            };
            "<leader>uC" = {
              action = ":Telescope colorscheme enable_preview=true<CR>";
              desc = "Colorscheme with Preview";
            };

            # LSP (LazyVim bindings)
            "gd" = {
              action = ":lua vim.lsp.buf.definition()<CR>";
              desc = "Goto Definition";
            };
            "gr" = {
              action = ":Telescope lsp_references<CR>";
              desc = "References";
            };
            "gI" = {
              action = ":Telescope lsp_implementations<CR>";
              desc = "Goto Implementation";
            };
            "gy" = {
              action = ":Telescope lsp_type_definitions<CR>";
              desc = "Goto T[y]pe Definition";
            };
            "gD" = {
              action = ":lua vim.lsp.buf.declaration()<CR>";
              desc = "Goto Declaration";
            };
            "K" = {
              action = ":lua vim.lsp.buf.hover()<CR>";
              desc = "Hover";
            };
            "gK" = {
              action = ":lua vim.lsp.buf.signature_help()<CR>";
              desc = "Signature Help";
            };
            "<leader>ca" = {
              action = ":lua vim.lsp.buf.code_action()<CR>";
              desc = "Code Action";
            };
            "<leader>cr" = {
              action = ":lua vim.lsp.buf.rename()<CR>";
              desc = "Rename";
            };

            # Code formatting
            "<leader>cf" = {
              action = ":lua vim.lsp.buf.format()<CR>";
              desc = "Format";
            };

            # Diagnostics (LazyVim style)
            "<leader>cd" = {
              action = ":lua vim.diagnostic.open_float()<CR>";
              desc = "Line Diagnostics";
            };
            "]d" = {
              action = ":lua vim.diagnostic.goto_next()<CR>";
              desc = "Next Diagnostic";
            };
            "[d" = {
              action = ":lua vim.diagnostic.goto_prev()<CR>";
              desc = "Prev Diagnostic";
            };
            "]e" = {
              action = ":lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>";
              desc = "Next Error";
            };
            "[e" = {
              action = ":lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>";
              desc = "Prev Error";
            };
            "]w" = {
              action = ":lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARN})<CR>";
              desc = "Next Warning";
            };
            "[w" = {
              action = ":lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARN})<CR>";
              desc = "Prev Warning";
            };

            # Buffers (LazyVim style)
            "<S-h>" = {
              action = ":bprevious<CR>";
              desc = "Prev Buffer";
            };
            "<S-l>" = {
              action = ":bnext<CR>";
              desc = "Next Buffer";
            };
            "[b" = {
              action = ":bprevious<CR>";
              desc = "Prev Buffer";
            };
            "]b" = {
              action = ":bnext<CR>";
              desc = "Next Buffer";
            };
            "<leader>bb" = {
              action = ":e #<CR>";
              desc = "Switch to Other Buffer";
            };
            "<leader>`" = {
              action = ":e #<CR>";
              desc = "Switch to Other Buffer";
            };
            "<leader>bd" = {
              action = ":bdelete<CR>";
              desc = "Delete Buffer";
            };
            "<leader>bo" = {
              action = ":%bd|e#|bd#<CR>";
              desc = "Delete Other Buffers";
            };
            "<leader>bD" = {
              action = ":bdelete!<CR>:q<CR>";
              desc = "Delete Buffer and Window";
            };

            # Clear search, diff update, redraw
            "<leader>ur" = {
              action = ":nohlsearch<bar>diffupdate<bar>normal! <C-L><CR>";
              desc = "Redraw / Clear hlsearch / Diff Update";
            };
            "<esc>" = {
              action = ":noh<CR><esc>";
              desc = "Escape and Clear hlsearch";
            };

            # Search
            "n" = {
              action = "nzzzv";
              desc = "Next Search Result";
            };
            "N" = {
              action = "Nzzzv";
              desc = "Prev Search Result";
            };

            # Better up/down
            "j" = {
              action = "v:count == 0 ? 'gj' : 'j'";
              desc = "Down";
              expr = true;
            };
            "<Down>" = {
              action = "v:count == 0 ? 'gj' : 'j'";
              desc = "Down";
              expr = true;
            };
            "k" = {
              action = "v:count == 0 ? 'gk' : 'k'";
              desc = "Up";
              expr = true;
            };
            "<Up>" = {
              action = "v:count == 0 ? 'gk' : 'k'";
              desc = "Up";
              expr = true;
            };

            # Move to window using the <ctrl> hjkl keys
            "<C-h>" = {
              action = "<C-w>h";
              desc = "Go to Left Window";
            };
            "<C-j>" = {
              action = "<C-w>j";
              desc = "Go to Lower Window";
            };
            "<C-k>" = {
              action = "<C-w>k";
              desc = "Go to Upper Window";
            };
            "<C-l>" = {
              action = "<C-w>l";
              desc = "Go to Right Window";
            };

            # Resize window using <ctrl> arrow keys
            "<C-Up>" = {
              action = ":resize +2<CR>";
              desc = "Increase Window Height";
            };
            "<C-Down>" = {
              action = ":resize -2<CR>";
              desc = "Decrease Window Height";
            };
            "<C-Left>" = {
              action = ":vertical resize -2<CR>";
              desc = "Decrease Window Width";
            };
            "<C-Right>" = {
              action = ":vertical resize +2<CR>";
              desc = "Decrease Window Width";
            };

            # Move Lines
            "<A-j>" = {
              action = ":m .+1<CR>==";
              desc = "Move Down";
            };
            "<A-k>" = {
              action = ":m .-2<CR>==";
              desc = "Move Up";
            };

            # Save file
            "<C-s>" = {
              action = ":w<CR>";
              desc = "Save File";
            };

            # New file
            "<leader>fn" = {
              action = ":enew<CR>";
              desc = "New File";
            };

            # Location and quickfix
            "<leader>xl" = {
              action = ":lopen<CR>";
              desc = "Location List";
            };
            "<leader>xq" = {
              action = ":copen<CR>";
              desc = "Quickfix List";
            };
            "[q" = {
              action = ":cprev<CR>";
              desc = "Previous Quickfix";
            };
            "]q" = {
              action = ":cnext<CR>";
              desc = "Next Quickfix";
            };

            # Git
            "<leader>gs" = {
              action = ":Telescope git_status<CR>";
              desc = "Git Status";
            };
            "<leader>gb" = {
              action = ":Gitsigns blame_line<CR>";
              desc = "Git Blame Line";
            };
            "<leader>gf" = {
              action = ":Telescope git_bcommits<CR>";
              desc = "Git File History";
            };
            "<leader>gl" = {
              action = ":Telescope git_commits<CR>";
              desc = "Git Log";
            };
            "<leader>gL" = {
              action = ":Telescope git_commits<CR>";
              desc = "Git Log (cwd)";
            };

            # Quit
            "<leader>qq" = {
              action = ":qa<CR>";
              desc = "Quit All";
            };

            # Lazy
            "<leader>l" = {
              action = ":Lazy<CR>";
              desc = "Lazy";
            };

            # Terminal
            "<leader>ft" = {
              action = ":ToggleTerm<CR>";
              desc = "Terminal (Root Dir)";
            };
            "<leader>fT" = {
              action = ":ToggleTerm<CR>";
              desc = "Terminal (cwd)";
            };
            "<c-/>" = {
              action = ":ToggleTerm<CR>";
              desc = "Terminal (Root Dir)";
            };

            # Windows
            "<leader>-" = {
              action = ":split<CR>";
              desc = "Split Window Below";
            };
            "<leader>|" = {
              action = ":vsplit<CR>";
              desc = "Split Window Right";
            };
            "<leader>wd" = {
              action = ":close<CR>";
              desc = "Delete Window";
            };

            # LazyGit
            "<leader>gg" = {
              action = ":LazyGit<CR>";
              desc = "Lazygit (Root Dir)";
            };
            "<leader>gG" = {
              action = ":LazyGitCurrentFile<CR>";
              desc = "Lazygit (cwd)";
            };

            # Which-key
            "<leader>?" = {
              action = ":WhichKey<CR>";
              desc = "Buffer Keymaps (which-key)";
            };
          };

          # Visual mode
          visual = {
            # Better indenting
            "<" = {
              action = "<gv";
              desc = "Unindent";
            };
            ">" = {
              action = ">gv";
              desc = "Indent";
            };

            # Move Lines
            "<A-j>" = {
              action = ":m '>+1<CR>gv=gv";
              desc = "Move Down";
            };
            "<A-k>" = {
              action = ":m '<-2<CR>gv=gv";
              desc = "Move Up";
            };

            # Search for selected text
            "<leader>sw" = {
              action = "\"+y:Telescope live_grep default_text=<C-r>+<CR>";
              desc = "Selection (Root Dir)";
            };
            "<leader>sW" = {
              action = "\"+y:Telescope live_grep cwd=false default_text=<C-r>+<CR>";
              desc = "Selection (cwd)";
            };
          };

          # Insert mode
          insert = {
            # Move Lines
            "<A-j>" = {
              action = "<esc>:m .+1<CR>==gi";
              desc = "Move Down";
            };
            "<A-k>" = {
              action = "<esc>:m .-2<CR>==gi";
              desc = "Move Up";
            };

            # Save file
            "<C-s>" = {
              action = "<esc>:w<CR>a";
              desc = "Save File";
            };

            # Signature help
            "<c-k>" = {
              action = ":lua vim.lsp.buf.signature_help()<CR>";
              desc = "Signature Help";
            };
          };

          # Terminal mode
          terminal = {
            # Hide terminal
            "<C-/>" = {
              action = "<cmd>close<CR>";
              desc = "Hide Terminal";
            };
            "<c-_>" = {
              action = "<cmd>close<CR>";
              desc = "which_key_ignore";
            };
          };
        };
      };
    };
  };
}
