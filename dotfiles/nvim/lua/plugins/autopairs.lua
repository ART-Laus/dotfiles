return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")

    npairs.setup({
      check_ts = true, -- использовать treesitter для лучшей контекстной логики
      ts_config = {
        lua = { "string" }, -- не вставлять скобки в строках
        javascript = { "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {
        map = "<M-e>", -- alt + e для быстрого оборачивания текста
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })

    -- интеграция с nvim-cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- Кастомные пары (пример)
    npairs.add_rules(require("nvim-autopairs.rules.endwise-lua")) -- автозакрытие "end" в lua
  end,
}
