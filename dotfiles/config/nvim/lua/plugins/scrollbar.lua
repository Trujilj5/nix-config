return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup()

      -- Integrate with scrollbar
      require("scrollbar.handlers.search").setup({
        override_lens = function() end,
      })
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        handle = {
          color = "#363a4f", -- catppuccin surface_0
        },
        marks = {
          Search = { color = "#eed49f" }, -- catppuccin yellow
          Error = { color = "#ed8796" }, -- catppuccin red
          Warn = { color = "#f5a97f" }, -- catppuccin peach
          Info = { color = "#8aadf4" }, -- catppuccin blue
          Hint = { color = "#8bd5ca" }, -- catppuccin teal
          Misc = { color = "#c6a0f6" }, -- catppuccin mauve
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })
    end,
  },
}
