-- Terminal configuration for LazyVim using Snacks
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.terminal = vim.tbl_deep_extend("force", opts.terminal or {}, {
        win = {
          height = 0.8,
          width = 0.8,
          style = "float",
          backdrop = 60,
          wo = {
            winblend = 10,
          },
        },
      })
      return opts
    end,
    keys = {
      -- Disable default keymaps
      { "<c-/>", false },
      { "<c-_>", false },
      
      -- Custom <C-t> terminal toggle (main terminal)
      {
        "<C-t>",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Toggle Terminal",
        mode = "n",
      },
      {
        "<C-t>",
        function()
          local win = vim.api.nvim_get_current_win()
          if vim.w[win].snacks_win then
            vim.w[win].snacks_win:hide()
          else
            vim.cmd("close")
          end
        end,
        desc = "Hide Terminal", 
        mode = "t",
      },
      
      -- Multiple terminals using different commands to create unique IDs
      {
        "<leader>t1",
        function()
          Snacks.terminal.toggle("terminal-1")
        end,
        desc = "Terminal 1",
      },
      {
        "<leader>t2", 
        function()
          Snacks.terminal.toggle("terminal-2")
        end,
        desc = "Terminal 2",
      },
      {
        "<leader>t3",
        function()
          Snacks.terminal.toggle("terminal-3")
        end,
        desc = "Terminal 3",
      },
      
      -- Keep LazyVim's ft and fT variants working
      {
        "<leader>ft",
        function()
          Snacks.terminal.toggle(nil, { cwd = LazyVim.root() })
        end,
        desc = "Terminal (Root Dir)",
      },
      {
        "<leader>fT",
        function()
          Snacks.terminal.toggle()
        end,
        desc = "Terminal (cwd)",
      },
    },
  },
}