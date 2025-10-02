-- Simple terminal configuration for LazyVim
return {
  {
    "folke/snacks.nvim",
    keys = {
      -- Disable default terminal keymaps
      { "<c-/>", false },
      { "<c-_>", false },
      
      -- Add <C-t> terminal keymaps
      {
        "<C-t>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
        mode = "n",
      },
      {
        "<C-t>",
        function()
          vim.cmd("close")
        end,
        desc = "Close Terminal",
        mode = "t",
      },
      
      -- Multiple terminals with unique IDs
      {
        "<leader>t1",
        function()
          Snacks.terminal(nil, { id = "term1" })
        end,
        desc = "Terminal 1",
      },
      {
        "<leader>t2",
        function()
          Snacks.terminal(nil, { id = "term2" })
        end,
        desc = "Terminal 2",
      },
      {
        "<leader>t3",
        function()
          Snacks.terminal(nil, { id = "term3" })
        end,
        desc = "Terminal 3",
      },
    },
  },
}