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

      -- Use colored underlines (cterm and gui)
      vim.cmd([[
        highlight DiagnosticUnderlineError cterm=underline gui=underline guisp=#ed8796 guifg=#ed8796
        highlight DiagnosticUnderlineWarn cterm=underline gui=underline guisp=#f5a97f guifg=#f5a97f
        highlight DiagnosticUnderlineInfo cterm=underline gui=underline guisp=#8aadf4 guifg=#8aadf4
        highlight DiagnosticUnderlineHint cterm=underline gui=underline guisp=#8bd5ca guifg=#8bd5ca
      ]])

      -- Remap K to show diagnostics if available, otherwise LSP hover
      vim.keymap.set("n", "K", function()
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diagnostics > 0 then
          vim.diagnostic.open_float(nil, { scope = "cursor" })
        else
          vim.lsp.buf.hover()
        end
      end, { desc = "Show diagnostics or hover" })

      return opts
    end,
  },
}
