-- Biome configuration for ionite project formatting and linting
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
      },
      formatters = {
        biome = {
          command = "biome",
          args = {
            "format",
            "--stdin-file-path",
            "$FILENAME",
          },
          stdin = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
      },
      linters = {
        biome = {
          cmd = "biome",
          args = {
            "lint",
            "--stdin-file-path",
            "$FILENAME",
            "--reporter",
            "json",
          },
          stdin = true,
          stream = "stdout",
          ignore_exitcode = true,
          parser = function(output)
            local diagnostics = {}
            local ok, decoded = pcall(vim.json.decode, output)
            if not ok or not decoded or not decoded.diagnostics then
              return diagnostics
            end
            
            for _, diagnostic in ipairs(decoded.diagnostics) do
              table.insert(diagnostics, {
                lnum = diagnostic.location.start.line - 1,
                col = diagnostic.location.start.column - 1,
                end_lnum = diagnostic.location["end"].line - 1,
                end_col = diagnostic.location["end"].column - 1,
                severity = diagnostic.severity == "error" and vim.diagnostic.severity.ERROR
                  or diagnostic.severity == "warning" and vim.diagnostic.severity.WARN
                  or vim.diagnostic.severity.INFO,
                message = diagnostic.message,
                source = "biome",
                code = diagnostic.code,
              })
            end
            
            return diagnostics
          end,
        },
      },
    },
  },
}