-- Parrot AI inline assistant
return {
  {
    "frankroeder/parrot.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    opts = {
      -- Pull API key from environment variable (set in your shell profile)
      -- Add to ~/.bashrc or ~/.zshrc: export ANTHROPIC_API_KEY="your-key-here"
      providers = {
        anthropic = {
          name = "anthropic",
          endpoint = "https://api.anthropic.com/v1/messages",
          api_key = os.getenv("ANTHROPIC_API_KEY"),
          params = {
            chat = { temperature = 1.0, max_tokens = 2048 },
            command = { temperature = 1.0, max_tokens = 1024 },
          },
          topic = {
            model = "claude-3-5-sonnet-20241022",
            params = { max_tokens = 64 },
          },
          models = {
            "claude-3-5-sonnet-20241022",
            "claude-3-5-haiku-20241022",
            "claude-3-opus-20250219",
          },
        },
      },
    },
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
