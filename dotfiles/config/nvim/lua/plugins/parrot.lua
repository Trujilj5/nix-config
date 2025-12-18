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
        -- Custom hooks
        hooks = {
          -- Fix errors/warnings from LSP
          FixDiagnostic = function(parrot, params)
            -- Get diagnostics for current buffer
            local bufnr = vim.api.nvim_get_current_buf()
            local diagnostics = vim.diagnostic.get(bufnr)

            -- Get the actual visual selection range
            local line_start = vim.fn.line("'<") - 1
            local line_end = vim.fn.line("'>") - 1
            local relevant_diags = {}

            for _, diag in ipairs(diagnostics) do
              if diag.lnum >= line_start and diag.lnum <= line_end then
                table.insert(relevant_diags, {
                  line = diag.lnum + 1,
                  message = diag.message,
                  severity = vim.diagnostic.severity[diag.severity],
                })
              end
            end

            -- Build diagnostics context string
            local diag_context = ""
            if #relevant_diags > 0 then
              diag_context = "\n\nLSP Diagnostics in this code:\n"
              for _, diag in ipairs(relevant_diags) do
                diag_context = diag_context .. string.format("- Line %d [%s]: %s\n", diag.line, diag.severity, diag.message)
              end
            end

            local template = [[
I have the following code from {{filename}}:

```{{filetype}}
{{selection}}
```
]] .. diag_context .. [[

{{command}}

Please fix the issues and respond exclusively with the corrected code snippet.
DO NOT include explanations or comments, just the fixed code.
]]
            local model_obj = parrot.get_model("command")
            parrot.logger.info("Fixing diagnostics with model: " .. model_obj.name)
            parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, nil, template)
          end,
        },
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
              -- Trim whitespace from message content
              for _, message in ipairs(payload.messages) do
                message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
              end
              -- Move system message to top-level parameter (Anthropic requirement)
              if payload.messages[1] and payload.messages[1].role == "system" then
                payload.system = payload.messages[1].content
                table.remove(payload.messages, 1)
              end
              return payload
            end,
            params = {
              chat = { max_tokens = 4096 },
              command = { max_tokens = 4096 },
            },
            topic = {
              model = "claude-sonnet-4-5",
              params = { max_tokens = 64 },
            },
            models = {
              "claude-sonnet-4-5",
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ai", "", desc = "+inline ai", mode = { "n", "v" } },
      {
        "<leader>air",
        ":'<,'>PrtRewrite<cr>",
        desc = "Inline Rewrite",
        mode = { "v" },
      },
      {
        "<leader>aif",
        ":'<,'>PrtFixDiagnostic<cr>",
        desc = "Fix LSP Errors",
        mode = { "v" },
      },
      {
        "<leader>aia",
        ":'<,'>PrtAppend<cr>",
        desc = "Inline Append",
        mode = { "v" },
      },
      {
        "<leader>aip",
        ":'<,'>PrtPrepend<cr>",
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
