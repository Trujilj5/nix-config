return {
	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
			local wk = require("which-key")
			-- Setup Which-Key with default or custom settings
			wk.setup({
				-- Your configuration comes here
				-- Left empty for default settings as in the original
			})

			-- Define keybinding for showing buffer-local keymaps
			vim.keymap.set("n", "<leader>?", function()
				wk.show({ global = false })
			end, { desc = "Buffer Local Keymaps (which-key)" })
		end,
	},
}
