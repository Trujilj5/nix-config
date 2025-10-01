-- Formatting and linting completely disabled
return {
  {
    "stevearc/conform.nvim",
    enabled = false,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Disable all linters to prevent biome ENOENT error
      linters_by_ft = {},
      linters = {},
    },
  },
}