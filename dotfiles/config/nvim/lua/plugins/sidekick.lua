-- Sidekick AI assistant for LazyVim
return {
  -- Copilot language server (required for Sidekick)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {},
      },
    },
  },

  -- Sidekick AI assistant
  {
    "folke/sidekick.nvim",
    opts = function()
      -- Accept inline suggestions or next edits (handled by ai-core.lua)
      LazyVim.cmp.actions.ai_nes = function()
        local Nes = require("sidekick.nes")
        if Nes.have() and (Nes.jump() or Nes.apply()) then
          return true
        end
      end
    end,
    -- stylua: ignore
    keys = {
      -- Tab key is handled by ai-core.lua for unified AI behavior
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
}