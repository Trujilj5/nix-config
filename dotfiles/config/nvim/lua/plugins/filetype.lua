-- Filetype configuration
return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Set .env files to conf filetype instead of sh
      vim.filetype.add({
        pattern = {
          ["%.env.*"] = "conf",
          ["%.env"] = "conf",
        },
      })
    end,
  },
}
