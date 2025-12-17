-- Parrot AI inline assistant
return {
  {
    "frankroeder/parrot.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    config = function()
      -- Pull API key from environment variable at runtime
      local api_key = vim.fn.getenv("ANTHROPIC_API_KEY")

      require("parrot").setup({
        -- Preview mode keybindings (when preview window is open):
        -- a or <CR> = apply changes
        -- r or <BS> = reject changes
        -- q, <Esc>, <C-c> = quit preview
        enable_preview_mode = true,
        providers = {
          anthropic = {
            name = "anthropic",
            endpoint = "https://api.anthropic.com/v1/messages",
            api_key = api_key,
            headers = function(self)
              return {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = self.api_key,
                ["anthropic-version"] = "2023-06-01",
              }
            end,
            preprocess_payload = function(payload)
              -- Anthropic doesn't accept "system" as a message role
              -- Extract system messages and move to top-level system parameter
              local system_messages = {}
              local user_messages = {}

              for _, message in ipairs(payload.messages or {}) do
                if message.role == "system" then
                  table.insert(system_messages, message.content)
                else
                  table.insert(user_messages, message)
                end
              end

              -- Set top-level system parameter if we found system messages
              if #system_messages > 0 then
                payload.system = table.concat(system_messages, "\n\n")
              end

              -- Update messages to only include non-system messages
              payload.messages = user_messages

              return payload
            end,
            params = {
              chat = { max_tokens = 4096 },
              command = { max_tokens = 4096 },
            },
            models = {
              "claude-sonnet-4-5-20250929",
              "claude-3-5-sonnet-20241022",
              "claude-3-5-haiku-20241022",
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ai", "", desc = "+inline ai", mode = { "n", "v" } },
      {
        "<leader>air",
        "<cmd>PrtRewrite<cr>",
        desc = "Inline Rewrite",
        mode = { "v" },
      },
      {
        "<leader>aia",
        "<cmd>PrtAppend<cr>",
        desc = "Inline Append",
        mode = { "v" },
      },
      {
        "<leader>aip",
        "<cmd>PrtPrepend<cr>",
        desc = "Inline Prepend",
        mode = { "v" },
      },
      {
        "<leader>aiR",
        "<cmd>PrtRetry<cr>",
        desc = "Inline Retry",
        mode = { "v" },
      },
    },
  },
}
