-- Parrot AI inline assistant
print("DEBUG: parrot.lua file is being loaded!")

return {
  {
    "frankroeder/parrot.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    config = function()
      -- Pull API key from environment variable at runtime
      local api_key = vim.fn.getenv("ANTHROPIC_API_KEY")

      print("DEBUG: API Key loaded: " .. (api_key ~= vim.NIL and "YES (length " .. #api_key .. ")" or "NO"))

      require("parrot").setup({
        providers = {
          anthropic = {
            name = "anthropic",
            endpoint = "https://api.anthropic.com/v1/messages",
            api_key = api_key,
            headers = function(self)
              local hdrs = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = self.api_key,
                ["anthropic-version"] = "2023-06-01",
              }
              print("DEBUG: Headers function called!")
              print("DEBUG: Headers = " .. vim.inspect(hdrs))
              return hdrs
            end,
            models = {
              "claude-3-5-sonnet-20241022",
              "claude-3-5-haiku-20241022",
              "claude-3-opus-20250219",
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
