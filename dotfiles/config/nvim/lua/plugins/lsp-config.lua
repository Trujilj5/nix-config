return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "yamlls", "jdtls" },
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({}) -- Lua
			lspconfig.ts_ls.setup({
				root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
					or vim.fn.getcwd(),
				single_file_support = true,
			})
			lspconfig.jdtls.setup({
				cmd = {
					vim.fn.stdpath("data") .. "/mason/bin/jdtls", -- Mason-installed jdtls binary
					"--jvm-arg=-Xmx2G", -- Optional: Increase memory (adjust as needed)
					"-data",
					vim.fn.expand("~/.cache/jdtls/workspace") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"), -- Workspace directory
				},
				root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git") or vim.fn.getcwd(),
				settings = {
					java = {
						configuration = {
							runtimes = { -- Optional: Define Java runtimes if you have multiple versions
								{
									name = "JavaSE-17",
									path = "/home/john/.jbang/currentjdk/",
								},
							},
						},
					},
				},
			})
			lspconfig.yamlls.setup({ -- YAML
				settings = {
					yaml = {
						schemas = {
							["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
						},
					},
				},
			})
		end,
	},
}
