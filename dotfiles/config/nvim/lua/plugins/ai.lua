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
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<Tab>",
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
        disable_inline_completion = false, -- Enable inline completion as fallback
        disable_keymaps = false,
      })

      -- Set up AI accept action for LazyVim
      LazyVim.cmp.actions.ai_accept = function()
        local suggestion = require("supermaven-nvim.completion_preview")
        if suggestion.has_suggestion() then
          suggestion.on_accept_suggestion()
          return true
        end
        return false
      end

      -- Status notification
      vim.defer_fn(function()
        local api = require("supermaven-nvim.api")
        if api.is_running() then
          vim.notify("✅ Supermaven is ready!", vim.log.levels.INFO, { title = "AI" })
        else
          vim.notify("⚠️  Supermaven not running - try :SupermavenStart", vim.log.levels.WARN, { title = "AI" })
        end
      end, 2000)
    end,
  },

  -- Enhanced nvim-cmp integration
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { 
      "supermaven-inc/supermaven-nvim",
    },
    opts = function(_, opts)
      -- Ensure sources table exists
      opts.sources = opts.sources or {}
      
      -- Add supermaven to completion sources
      table.insert(opts.sources, 1, {
        name = "supermaven",
        group_index = 1,
        priority = 100,
        max_item_count = 5,
      })

      -- Enhanced formatting for supermaven
      if not opts.formatting then
        opts.formatting = {}
      end
      
      local original_format = opts.formatting.format
      opts.formatting.format = function(entry, vim_item)
        -- Apply original formatting if it exists
        if original_format then
          vim_item = original_format(entry, vim_item)
        end
        
        -- Add supermaven icon and styling
        if entry.source.name == "supermaven" then
          vim_item.kind = "🤖"
          vim_item.kind_hl_group = "CmpItemKindSupermaven"
          vim_item.menu = "[AI]"
        end
        
        return vim_item
      end

      return opts
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      
      -- Set up highlight group for supermaven
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
      
      -- Debug: Check if supermaven source is registered
      vim.defer_fn(function()
        local sources = cmp.get_config().sources or {}
        local has_supermaven = false
        for _, source in ipairs(sources) do
          if source.name == "supermaven" then
            has_supermaven = true
            break
          end
        end
        
        if has_supermaven then
          vim.notify("✅ Supermaven CMP source registered", vim.log.levels.INFO, { title = "AI" })
        else
          vim.notify("❌ Supermaven CMP source not found", vim.log.levels.ERROR, { title = "AI" })
        end
      end, 3000)
    end,
  },
}