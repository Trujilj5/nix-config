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
      -- Store terminal style preference
      _G.terminal_is_bottom = false
      
      local function get_terminal_config()
        if _G.terminal_is_bottom then
          return {
            win = {
              position = "bottom",
              height = 15,
              backdrop = false,
            }
          }
        else
          return {
            win = {
              height = 0.8,
              width = 0.8,
              style = "float",
              backdrop = 60,
            }
          }
        end
      end
      
      local function toggle_terminal_style()
        -- Close current main terminal if open
        local main_terminal = Snacks.terminal.get(nil, { create = false })
        if main_terminal and main_terminal:valid() then
          main_terminal:close()
        end
        
        -- Toggle style
        _G.terminal_is_bottom = not _G.terminal_is_bottom
        
        -- Open terminal with new style
        local config = get_terminal_config()
        Snacks.terminal.toggle(nil, config)
        
        -- Notify user
        local mode = _G.terminal_is_bottom and "Bottom" or "Float"
        vim.notify("Terminal: " .. mode .. " mode", vim.log.levels.INFO)
      end
      
      -- Override the main terminal toggle to use current style
      local function smart_terminal_toggle()
        local config = get_terminal_config()
        Snacks.terminal.toggle(nil, config)
      end
      
      -- Make functions globally accessible
      _G.toggle_terminal_style = toggle_terminal_style
      _G.smart_terminal_toggle = smart_terminal_toggle
    end,
    keys = {
      -- Disable default keymaps
      { "<c-/>", false },
      { "<c-_>", false },
      
      -- Custom <C-t> terminal toggle (main terminal)
      {
        "<C-t>",
        function()
          _G.smart_terminal_toggle()
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