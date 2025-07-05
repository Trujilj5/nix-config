-- Basic settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "
vim.wo.number = true
vim.wo.relativenumber = true

-- Indent lines
vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent line" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selected lines" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent selected lines" })

-- Neovim Keybinds
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })

-- LSP Keybinds
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>ga", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Neotree Keybinds
vim.keymap.set("n", "<leader>e", ":Neotree<CR>", { desc = "Open Neotree" })
vim.keymap.set("n", "<leader>c", ":Neotree action=close<CR>", { desc = "Close Neotree" })
vim.keymap.set("n", "<leader>gs", ":Neotree float git_status<CR>", { desc = "Show Git status in Neotree" })

-- Diffview Keybinds
vim.keymap.set("n", "<leader>vv", ":DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>v ", ":DiffviewOpen<CR>", { desc = "Open Diffview" })

-- Barbar Keybinds
vim.keymap.set("n", "<leader>n", "<Cmd>BufferNext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>b", "<Cmd>BufferNext<CR>", { desc = "Go to previous buffer" })
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
