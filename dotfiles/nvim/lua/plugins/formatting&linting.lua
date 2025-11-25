-- ~/.config/nvim/lua/plugins/formatting&linting.lua
return {
    -- 🔧 Conform — автоформатирование
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                astro = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                templ = { "prettierd" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                tsx = { "prettierd" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
                lua = { "stylua" },
                mdx = { "prettierd" },
                nix = { "nixfmt" },
                python = { "isort", "black" },
                rust = { "rustfmt" },
                svelte = { "prettierd" },
                verilog = { "verible" },
                typst = { "typstyle" },
                yaml = { "prettierd" },
            },

            format_after_save = {
                lsp_fallback = true,
                quiet = true,
            },

            formatters = {
                gdformat = {
                    command = "gdformat",
                    args = "$FILENAME",
                    stdin = false,
                },
                verible = {
                    command = "verible-verilog-format",
                    prepend_args = { "--indentation_spaces", "4" },
                },
            },
        },
    },

    -- 🔍 nvim-lint — линтинг
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- 🔹 путь к Mason bin (чтобы линтеры точно нашлись)
            local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
            vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

            lint.linters_by_ft = {
                astro = { "eslint_d" },
                javascript = { "eslint_d" },
                svelte = { "eslint_d" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                html = { "eslint_d" },
                templ = { "eslint_d" },
                tsx = { "eslint_d" },
                python = { "flake8" }, -- Python
            }

            -- 🔧 безопасный вызов линтинга (чтобы не было ошибок, если линтер не найден)
            local function safe_lint()
                local ok = pcall(lint.try_lint)
                if not ok then
                    vim.schedule(function()
                        vim.api.nvim_echo({
                            { "⚠ lint skipped (tool not found)", "WarningMsg" },
                        }, false, {})
                    end)
                end
            end

            -- ⚡ Автоматический запуск линтинга
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    safe_lint()
                end,
            })
        end,
    },
}
