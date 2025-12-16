-- Parrot AI inline assistant
return {
  {
    "frankroeder/parrot.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Pull API key from environment variable (set in your shell profile)
      -- Add to ~/.bashrc or ~/.zshrc: export ANTHROPIC_API_KEY="your-key-here"
      providers = {
        anthropic = {
          api_key = os.getenv("ANTHROPIC_API_KEY"),
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
