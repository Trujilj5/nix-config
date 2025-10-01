-- AI plugins configuration for LazyVim
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
        accept_suggestion = nil, -- We'll handle this manually
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

      -- Helper function to safely accept suggestions
      local function safe_accept_suggestion()
        local suggestion = require("supermaven-nvim.completion_preview")
        if not suggestion.has_suggestion() then
          return false
        end

        -- Use vim.schedule to defer the text modification
        vim.schedule(function()
          -- Check if we can modify the buffer
          if vim.bo.modifiable and not vim.bo.readonly then
            local ok, err = pcall(suggestion.on_accept_suggestion)
            if not ok then
              vim.notify("Failed to accept suggestion: " .. tostring(err), vim.log.levels.WARN, { title = "AI" })
            end
          end
        end)
        return true
      end

      -- Set up LazyVim AI accept action
      LazyVim.cmp.actions.ai_accept = safe_accept_suggestion

      -- Custom Tab keymap for insert mode
      vim.keymap.set("i", "<Tab>", function()
        local suggestion = require("supermaven-nvim.completion_preview")
        if suggestion.has_suggestion() then
          if safe_accept_suggestion() then
            return ""
          end
        end
        -- Fall back to normal Tab behavior
        return "<Tab>"
      end, { 
        expr = true, 
        silent = true, 
        desc = "Accept AI suggestion or insert tab",
        buffer = false -- Apply globally
      })

      -- Status notification with delay
      vim.defer_fn(function()
        local ok, api = pcall(require, "supermaven-nvim.api")
        if ok and api.is_running() then
          vim.notify("✅ Supermaven is ready!", vim.log.levels.INFO, { title = "AI" })
        else
          vim.notify("⚠️ Supermaven not running - try :SupermavenStart", vim.log.levels.WARN, { title = "AI" })
        end
      end, 3000)
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

  -- Blink.cmp integration (optional, if using blink.cmp)
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { 
      "supermaven-inc/supermaven-nvim",
      "saghen/blink.compat"
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.sources = opts.sources or {}
      
      -- Add supermaven to blink sources
      if not opts.sources.default then
        opts.sources.default = {}
      end
      
      table.insert(opts.sources.default, "supermaven")
      
      -- Configure supermaven provider
      if not opts.sources.providers then
        opts.sources.providers = {}
      end
      
      opts.sources.providers.supermaven = {
        name = "supermaven",
        module = "blink.compat.source",
      }

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