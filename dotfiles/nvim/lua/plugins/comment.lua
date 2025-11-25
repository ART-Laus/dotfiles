return {
    {
        "numToStr/Comment.nvim",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })

            require("Comment").setup({
                padding = true,
                sticky = true,
                toggler = {
                    line = "<leader>c",  -- Пробел + c для линейного комментария
                    block = "<leader>C", -- Пробел + Shift + C для блочного
                },
                opleader = {
                    line = "<leader>c",
                    block = "<leader>C",
                },
                extra = {
                    above = "gcO",
                    below = "gco",
                    eol = "gcA",
                },
                mappings = {
                    basic = true,
                    extra = true,
                },
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },
}
