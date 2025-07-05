return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "biome", "prettier" }, -- Fallback to prettier if biome fails
					typescript = { "biome", "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
				},
				format_on_save = false,
			})
			-- Map <leader>gg to format
			vim.keymap.set("n", "<leader>gg", function()
				require("conform").format({ bufnr = vim.api.nvim_get_current_buf(), lsp_fallback = true })
			end, { desc = "Format file with conform" })
		end,
	},
}
