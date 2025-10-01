-- Supermaven AI completion for LazyVim
-- Set global variable early to ensure proper loading order
vim.g.ai_cmp = true

return {
  -- Supermaven AI completion
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenStart",
      "SupermavenStop", 
      "SupermavenRestart",
      "SupermavenToggle",
      "SupermavenStatus",
      "SupermavenUseFree",
      "SupermavenUsePro",
      "SupermavenLogout",
      "SupermavenShowLog",
      "SupermavenClearLog",
    },
    opts = {
      keymaps = {
        accept_suggestion = nil, -- Handled by unified AI core
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { 
        "bigfile", 
        "snacks_input", 
        "snacks_notif" 
      },
      color = {
        suggestion_color = "#ffffff",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = false,
      disable_keymaps = false,
    },
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)
      -- Key mappings and status notifications are handled by ai-core.lua
    end,
  },

  -- Enhanced nvim-cmp integration
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    event = "InsertEnter",
    dependencies = { 
      "supermaven-inc/supermaven-nvim",
    },
    opts = function(_, opts)
      -- Initialize opts if not present
      opts = opts or {}
      opts.sources = opts.sources or {}
      
      -- Add supermaven to completion sources with high priority
      table.insert(opts.sources, 1, {
        name = "supermaven",
        group_index = 1,
        priority = 100,
        max_item_count = 3,
      })

      -- Enhanced formatting
      if not opts.formatting then
        opts.formatting = {}
      end
      
      local original_format = opts.formatting.format
      opts.formatting.format = function(entry, vim_item)
        -- Apply original formatting if it exists
        if original_format then
          vim_item = original_format(entry, vim_item)
        end
        
        -- Add supermaven specific styling
        if entry.source.name == "supermaven" then
          vim_item.kind = "🤖"
          vim_item.kind_hl_group = "CmpItemKindSupermaven"
          vim_item.menu = "[AI]"
          vim_item.dup = 0 -- Don't show duplicates
        end
        
        return vim_item
      end

      return opts
    end,
  },

  -- Set up custom highlight groups
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Set up highlight group for supermaven in cmp
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { 
        fg = "#6CC644", 
        bold = true 
      })
    end,
  },
}