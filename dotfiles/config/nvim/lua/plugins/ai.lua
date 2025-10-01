-- AI plugins configuration for LazyVim
return {
  -- Sidekick AI assistant
  {
    "folke/sidekick.nvim",
    opts = function()
      -- Accept inline suggestions or next edits
      LazyVim.cmp.actions.ai_nes = function()
        local Nes = require("sidekick.nes")
        if Nes.have() and (Nes.jump() or Nes.apply()) then
          return true
        end
      end
    end,
    -- stylua: ignore
    keys = {
      -- nes is also useful in normal mode
      { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
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

  -- Copilot language server for Sidekick
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {},
      },
    },
  },

  -- Supermaven AI completion
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenUseFree",
      "SupermavenUsePro",
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
          accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
        },
        disable_inline_completion = true, -- Use cmp integration instead
        disable_keymaps = true, -- Let cmp handle keymaps
        ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
        condition = function()
          return vim.g.ai_cmp ~= false
        end,
      }
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
        
        -- Add supermaven to formatting
        if opts.formatting and opts.formatting.format then
          local original_format = opts.formatting.format
          opts.formatting.format = function(entry, vim_item)
            vim_item = original_format(entry, vim_item)
            if entry.source.name == "supermaven" then
              vim_item.kind = "🤖 " .. (vim_item.kind or "")
            end
            return vim_item
          end
        end
      end
    end,
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

  -- Debug and status check for Supermaven
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      -- Add autocmd to check Supermaven status
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            local ok, supermaven = pcall(require, "supermaven-nvim")
            if ok then
              print("✅ Supermaven loaded successfully")
              -- Check if API is running
              vim.defer_fn(function()
                if supermaven.api and supermaven.api.is_running then
                  if supermaven.api.is_running() then
                    print("✅ Supermaven API is running")
                  else
                    print("⚠️  Supermaven API not running - try :SupermavenStart")
                  end
                end
              end, 2000)
            else
              print("❌ Failed to load Supermaven: " .. tostring(supermaven))
            end
          end, 1000)
        end,
      })
    end,
  },
}