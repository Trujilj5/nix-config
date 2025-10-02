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
        },
      })
      return opts
    end,
    config = function()
      -- Toggle terminal style between float and bottom
      _G.terminal_style = "float" -- Track current style
      
      local function toggle_terminal_style()
        local current_terminals = Snacks.terminal.list()
        
        -- Close all open terminals first
        for _, term in ipairs(current_terminals) do
          if term:valid() then
            term:close()
          end
        end
        
        -- Toggle style
        if _G.terminal_style == "float" then
          _G.terminal_style = "bottom"
          -- Open main terminal in bottom style
          Snacks.terminal.toggle(nil, {
            win = {
              position = "bottom",
              height = 15,
              backdrop = false,
            }
          })
          vim.notify("Terminal: Bottom mode", vim.log.levels.INFO)
        else
          _G.terminal_style = "float"
          -- Open main terminal in float style
          Snacks.terminal.toggle(nil, {
            win = {
              height = 0.8,
              width = 0.8,
              style = "float",
              backdrop = 60,
            }
          })
          vim.notify("Terminal: Float mode", vim.log.levels.INFO)
        end
      end
      
      -- Make function globally accessible
      _G.toggle_terminal_style = toggle_terminal_style
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
          vim.cmd("close")
        end,
        desc = "Hide Terminal", 
        mode = "t",
      },
      
      -- Multiple terminals using different commands to create unique IDs
      {
        "<leader>t1",
        function()
          Snacks.terminal.toggle(nil, { env = { TERMINAL_ID = "1" } })
        end,
        desc = "Terminal 1",
      },
      {
        "<leader>t2", 
        function()
          Snacks.terminal.toggle(nil, { env = { TERMINAL_ID = "2" } })
        end,
        desc = "Terminal 2",
      },
      {
        "<leader>t3",
        function()
          Snacks.terminal.toggle(nil, { env = { TERMINAL_ID = "3" } })
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
      
      -- Toggle terminal style between float and bottom
      {
        "<leader>tt",
        function()
          _G.toggle_terminal_style()
        end,
        desc = "Toggle Terminal Style (Float/Bottom)",
      },
    },
  },
}