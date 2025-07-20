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

-- Indent lines
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

-- Neotree Keybinds
vim.keymap.set("n", "<leader>e", ":Neotree<CR>", { desc = "Open Neotree" })
vim.keymap.set("n", "<leader>c", ":Neotree action=close<CR>", { desc = "Close Neotree" })
vim.keymap.set("n", "<leader>gs", ":Neotree float git_status<CR>", { desc = "Show Git status in Neotree" })

-- Buffer navigation (Barbar)
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

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
