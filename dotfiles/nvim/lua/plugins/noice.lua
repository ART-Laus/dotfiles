return {
	"folke/noice.nvim",
	lazy = false,
	opts = {
		lsp = {
			signature = {
				enabled = true,
				auto_open = {
					enabled = true,
					trigger = true,
					luasnip = true,
					throttle = 50,
				},
				view = nil,
				opts = {},
			},
			override = {},
		},

		-- =====================[ CMDLINE / SEARCH UI ]=====================
		cmdline = {
			enabled = true,
			view = "cmdline_popup", -- вверхний popup вместо нижнего
			format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
			},
		},

		views = {
			cmdline_popup = {
				position = { row = "10%", col = "50%" },
				size = { width = "60%", height = "auto" },
				border = { style = "rounded", padding = { 0, 1 } },
				win_options = {
					winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
				},
			},
		},

		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},

		presets = {
			bottom_search = false, -- отключаем нижний cmdline
			command_palette = true, -- включаем верхний cmdline
			long_message_to_split = true,
		},
	},

	keys = {
		{ "<leader>sn", "", desc = "+noice" },
		{
			"<S-Enter>",
			function()
				require("noice").redirect(vim.fn.getcmdline())
			end,
			mode = "c",
			desc = "Redirect Cmdline",
		},
		{
			"<leader>snl",
			function()
				require("noice").cmd("last")
			end,
			desc = "Noice Last Message",
		},
		{
			"<leader>snh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Noice History",
		},
		{
			"<leader>sna",
			function()
				require("noice").cmd("all")
			end,
			desc = "Noice All",
		},
		{
			"<leader>snd",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
		{
			"<leader>snt",
			function()
				require("noice").cmd("pick")
			end,
			desc = "Noice Picker (Telescope/FzfLua)",
		},
		{
			"<c-f>",
			function()
				if not require("noice.lsp").scroll(4) then
					return "<c-f>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Forward",
			mode = { "i", "n", "s" },
		},
		{
			"<c-b>",
			function()
				if not require("noice.lsp").scroll(-4) then
					return "<c-b>"
				end
			end,
			silent = true,
			expr = true,
			desc = "Scroll Backward",
			mode = { "i", "n", "s" },
		},
	},

	config = function(_, opts)
		if vim.o.filetype == "lazy" then
			vim.cmd([[messages clear]])
		end
		require("noice").setup(opts)

		-- Немного зелёной стилизации (под твою тему)
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "NONE", fg = "#66FF99" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#58FFD6", bg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#58FFD6", bg = "NONE" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = "#66FF99", bg = "NONE", bold = true })
	end,
}
