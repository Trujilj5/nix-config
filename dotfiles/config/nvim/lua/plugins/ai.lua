-- AI plugins configuration for LazyVim
return {
  -- Supermaven AI completion (independent, no copilot needed)
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
    opts = function()
      -- Enable AI completion in cmp
      vim.g.ai_cmp = true
      
      require("supermaven-nvim.completion_preview").suggestion_group = "SupermavenSuggestion"
      
      LazyVim.cmp.actions.ai_accept = function()
        local suggestion = require("supermaven-nvim.completion_preview")
        if suggestion.has_suggestion() then
          LazyVim.create_undo()
          vim.schedule(function()
            suggestion.on_accept_suggestion()
          end)
          return true
        end
      end

      return {
        keymaps = {
          accept_suggestion = nil, -- handled by nvim-cmp
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        disable_inline_completion = true, -- Use cmp integration instead
        disable_keymaps = false, -- Keep some keymaps for manual control
        ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
        log_level = "info",
        condition = function()
          return false -- Always enabled
        end,
      }
    end,
    config = function(_, opts)
      require("supermaven-nvim").setup(opts)
      
      -- Add status check autocmd
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            local ok, api = pcall(require, "supermaven-nvim.api")
            if ok then
              vim.notify("✅ Supermaven loaded successfully", vim.log.levels.INFO, { title = "Supermaven" })
              -- Check if API is running after a delay
              vim.defer_fn(function()
                if api.is_running() then
                  vim.notify("✅ Supermaven API is running", vim.log.levels.INFO, { title = "Supermaven" })
                else
                  vim.notify("⚠️  Supermaven API not running - try :SupermavenStart", vim.log.levels.WARN, { title = "Supermaven" })
                end
              end, 2000)
            else
              vim.notify("❌ Failed to load Supermaven", vim.log.levels.ERROR, { title = "Supermaven" })
            end
          end, 1000)
        end,
      })
    end,
  },

  -- nvim-cmp integration for Supermaven
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "supermaven-nvim" },
    opts = function(_, opts)
      if vim.g.ai_cmp then
        -- Ensure sources table exists
        opts.sources = opts.sources or {}
        
        table.insert(opts.sources, 1, {
          name = "supermaven",
          group_index = 1,
          priority = 100,
        })
        
        -- Add supermaven formatting with icon
        if opts.formatting and opts.formatting.format then
          local original_format = opts.formatting.format
          opts.formatting.format = function(entry, vim_item)
            vim_item = original_format(entry, vim_item)
            if entry.source.name == "supermaven" then
              vim_item.kind = "🤖 " .. (vim_item.kind or "AI")
            end
            return vim_item
          end
        end
      end
    end,
  },

  -- Sidekick AI assistant (requires Copilot)
  -- Uncomment the sections below if you want to use Sidekick alongside Supermaven
  --[[
  {
    "folke/sidekick.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = function()
      -- Accept inline suggestions or next edits
      LazyVim.cmp.actions.ai_nes = function()
        local Nes = require("sidekick.nes")
        if Nes.have() and (Nes.jump() or Nes.apply()) then
          return true
        end
      end
    end,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        mode = { "n" },
        desc = "Sidekick Select CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").send() end,
        mode = { "v" },
        desc = "Sidekick Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        desc = "Sidekick Select Prompt",
        mode = { "n", "v" },
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
    },
  },

  -- Copilot language server (only needed for Sidekick)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {},
      },
    },
  },

  -- Lualine integration for Sidekick status
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local icons = {
        Error = { " ", "DiagnosticError" },
        Inactive = { " ", "MsgArea" },
        Warning = { " ", "DiagnosticWarn" },
        Normal = { LazyVim.config.icons.kinds.Copilot, "Special" },
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = require("sidekick.status").get()
          return status and vim.tbl_get(icons, status.kind, 1)
        end,
        cond = function()
          return require("sidekick.status").get() ~= nil
        end,
        color = function()
          local status = require("sidekick.status").get()
          local hl = status and (status.busy and "DiagnosticWarn" or vim.tbl_get(icons, status.kind, 2))
          return { fg = Snacks.util.color(hl) }
        end,
      })
    end,
  },
  --]]
}