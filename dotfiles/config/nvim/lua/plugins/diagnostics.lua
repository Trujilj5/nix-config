return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.underline = true
      opts.diagnostics.update_in_insert = false
      opts.diagnostics.virtual_text = false
      opts.diagnostics.severity_sort = true

      -- Configure undercurl highlights
      vim.diagnostic.config({
        underline = {
          severity = { min = vim.diagnostic.severity.HINT },
        },
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Ensure undercurl is visible
      vim.cmd([[
        highlight DiagnosticUnderlineError gui=undercurl guisp=#ed8796
        highlight DiagnosticUnderlineWarn gui=undercurl guisp=#f5a97f
        highlight DiagnosticUnderlineInfo gui=undercurl guisp=#8aadf4
        highlight DiagnosticUnderlineHint gui=undercurl guisp=#8bd5ca
      ]])

      return opts
    end,
  },
}
