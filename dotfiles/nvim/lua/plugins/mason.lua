return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		build = ":MasonUpdate",
		config = true,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"rust_analyzer",
					"clangd",
					"html",
					"cssls",
					"tailwindcss",
					"jsonls",
					"bashls",
					"tsserver",
					"emmet_ls",
					"marksman",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"isort",
					"flake8",
					"eslint_d",
					"prettierd",
					"stylua",
					"rustfmt",
					"nixfmt",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
}
