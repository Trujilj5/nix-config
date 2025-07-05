return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
      'lewis6991/gitsigns.nvim',
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- Basic setup with minimal options
			vim.g.barbar_auto_setup = false
			require("barbar").setup({
				animation = true,
				auto_hide = false,
				clickable = true,
				icons = {
					buffer_index = false,
					filetype = { enabled = true },
					separator = { left = "▎", right = "" },
				},
			})
		end,
	},
}
