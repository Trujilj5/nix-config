-- Custom terminal configuration for LazyVim
return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          style = "terminal",
          backdrop = 60,
          height = 0.8,
          width = 0.8,
          wo = {
            winblend = 0,
            winhighlight = "Normal:SnacksTerminalNormal,FloatBorder:SnacksTerminalBorder",
          },
        },
      },
    },
    keys = {
      {
        "<C-t>",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
        mode = { "n", "t" },
      },
      {
        "<leader>ft",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root.get() })
        end,
        desc = "Terminal (Root Dir)",
      },
      {
        "<leader>fT",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal (cwd)",
      },
      {
        "<leader>t1",
        function()
          Snacks.terminal(nil, { name = "term1" })
        end,
        desc = "Terminal 1",
      },
      {
        "<leader>t2",
        function()
          Snacks.terminal(nil, { name = "term2" })
        end,
        desc = "Terminal 2",
      },
      {
        "<leader>t3",
        function()
          Snacks.terminal(nil, { name = "term3" })
        end,
        desc = "Terminal 3",
      },
    },
    config = function(_, opts)
      -- Set up highlight groups for better terminal styling
      vim.api.nvim_set_hl(0, "SnacksTerminalNormal", { 
        bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg") or "NONE",
        fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg") or "NONE"
      })
      vim.api.nvim_set_hl(0, "SnacksTerminalBorder", { 
        fg = vim.fn.synIDattr(vim.fn.hlID("FloatBorder"), "fg") or "#7aa2f7",
        bg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg") or "NONE"
      })
      
      -- Safely remove original keymaps to avoid conflicts
      pcall(vim.keymap.del, "n", "<c-/>")
      pcall(vim.keymap.del, "n", "<c-_>") 
      pcall(vim.keymap.del, "t", "<C-/>")
      
      -- Add terminal hide keybinding for <C-t> in terminal mode
      vim.keymap.set("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal", silent = true })
    end,
  },
}