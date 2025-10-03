return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false, -- Disable text at end of line
        severity_sort = true,
      },
    },
  },
}
