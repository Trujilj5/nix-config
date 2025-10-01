-- Unified AI core configuration to handle conflicts between Supermaven and Sidekick
-- This file manages the Tab key behavior and AI action coordination

return {
  -- Core AI key mapping coordination
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Set up unified AI accept function that handles both Supermaven and Sidekick
      LazyVim.cmp.actions.ai_unified = function()
        -- First try Sidekick NES (Next Edit Suggestions)
        local nes_ok, nes = pcall(require, "sidekick.nes")
        if nes_ok and nes.have() and (nes.jump() or nes.apply()) then
          return true
        end

        -- Then try Supermaven suggestions
        local sm_ok, suggestion = pcall(require, "supermaven-nvim.completion_preview")
        if sm_ok and suggestion.has_suggestion() then
          vim.schedule(function()
            if vim.bo.modifiable and not vim.bo.readonly then
              local accept_ok, err = pcall(suggestion.on_accept_suggestion)
              if not accept_ok then
                vim.notify("Failed to accept Supermaven suggestion: " .. tostring(err), vim.log.levels.WARN, { title = "AI" })
              end
            end
          end)
          return true
        end

        return false
      end

      -- Override the default ai_accept to use our unified function
      LazyVim.cmp.actions.ai_accept = LazyVim.cmp.actions.ai_unified
    end,
  },

  -- Unified Tab key mapping for insert mode
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<Tab>",
        function()
          -- Try unified AI accept first
          if LazyVim.cmp.actions.ai_unified() then
            return ""
          end
          -- Fall back to normal Tab behavior
          return "<Tab>"
        end,
        mode = "i",
        expr = true,
        silent = true,
        desc = "Accept AI suggestion or insert tab",
      },
    },
  },

  -- Global AI status management
  {
    "LazyVim/LazyVim",
    config = function()
      -- Create autocmd to check AI plugin status
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            local status_messages = {}

            -- Check Supermaven status
            local sm_ok, sm_api = pcall(require, "supermaven-nvim.api")
            if sm_ok then
              if sm_api.is_running() then
                table.insert(status_messages, "✅ Supermaven ready")
              else
                table.insert(status_messages, "⚠️ Supermaven not running")
              end
            end

            -- Check Sidekick status
            local sk_ok, sk_status = pcall(require, "sidekick.status")
            if sk_ok then
              local status = sk_status.get()
              if status then
                table.insert(status_messages, "✅ Sidekick ready")
              else
                table.insert(status_messages, "⚠️ Sidekick not active")
              end
            end

            -- Show combined status
            if #status_messages > 0 then
              vim.notify(table.concat(status_messages, "\n"), vim.log.levels.INFO, { title = "AI Plugins" })
            end
          end, 3000)
        end,
      })
    end,
  },
}