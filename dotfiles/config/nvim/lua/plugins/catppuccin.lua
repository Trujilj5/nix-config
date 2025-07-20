return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- Only set colorscheme if Stylix hasn't already set one
    if not vim.g.colors_name then
      vim.cmd.colorscheme "catppuccin"
    end
  end
}
