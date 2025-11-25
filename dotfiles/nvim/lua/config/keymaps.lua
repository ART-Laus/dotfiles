local opts = { noremap = true, silent = true }
local keymap = vim.keymap

-- Сохранение
vim.api.nvim_set_keymap("", "<C-s>", "<cmd>w<CR>", opts)

-- Переназначение командного режима на /
vim.api.nvim_set_keymap("n", "/", ":", { noremap = true, silent = false })
vim.api.nvim_set_keymap("v", "/", ":", { noremap = true, silent = false })

-- ===================================================

-- Инкремент\Декремент
vim.keymap.set("n", "=", "<C-a>", { noremap = true, silent = true })
vim.keymap.set("n", "-", "<C-x>", { noremap = true, silent = true })

-- Удалить слово позади
vim.keymap.set("n", "dw", 'vb"_d')

-- Выделить всё
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Клонировать строку
vim.keymap.set("n", "cl", "Yp", opts)
vim.keymap.set("v", "cl", "Yp", opts)

-- Начало/конец строки
vim.api.nvim_set_keymap("n", "sl", "^", opts)
vim.api.nvim_set_keymap("n", "el", "$", opts)
vim.api.nvim_set_keymap("v", "sl", "^", opts)
vim.api.nvim_set_keymap("v", "el", "$", opts)

-- Перемещение строки вверх/вниз в нормальном и визуальном режимах
vim.keymap.set("n", "<A-S-j>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-S-k>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Прыжки вперёд/назад по словам
vim.keymap.set("n", "nw", "w", { noremap = true, silent = true })
vim.keymap.set("n", "bw", "b", { noremap = true, silent = true })

-- Переход внутрь круглых скобок
vim.keymap.set("n", "f(", "f(l", { noremap = true, silent = true })
-- Переход внутрь квадратных скобок
vim.keymap.set("n", "f]", "f[l", { noremap = true, silent = true })
-- Переход внутрь фигурных скобок
vim.keymap.set("n", "f}", "f{l", { noremap = true, silent = true })
-- Улучшеная работа с табами
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Поиск
vim.keymap.set("n", ".", "/", { noremap = true })
vim.keymap.set("n", ",", "?", { noremap = true })
-- Вперёд-назад
vim.keymap.set("n", "m", "nzzzv")
vim.keymap.set("n", "M", "Nzzzv")

-- Снять выделение слова после поиска
vim.keymap.set("i", "<C-m>", "<Esc>")
vim.keymap.set("n", "<C-m>", ":nohl<CR>", { desc = "Clear search hl", silent = true })

-- Переключение между буферами
vim.keymap.set("n", "<Leader>j", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>k", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bdelete<CR>", { silent = true })

-- toggle line wrapping
vim.keymap.set("n", "<Leader>lw", "<cmd>set wrap!<CR>", opts)

-- Инкрементальное выделение слов с последующей заменой
local function smart_word_select()
	local mode = vim.fn.mode()
	if mode == "n" then
		-- В нормальном режиме, начинаем с выделения слова
		vim.api.nvim_feedkeys("viw", "n", true)
	elseif mode == "v" then
		-- В визуальном режиме, расширяем выделение на следующее слово
		vim.api.nvim_feedkeys("w", "n", true)
	end
end

vim.keymap.set(
	{ "n", "v" },
	"sw",
	smart_word_select,
	{ noremap = true, silent = true, desc = "Инкрементальное выделение слов" }
)

-- Интерактивный поиск и замена
local function InteractiveReplace(scope)
	local search_term = vim.fn.getreg("/")
	if search_term == "" then
		print("Нет выражения для поиска в регистре.")
		return
	end

	local replacement = vim.fn.input('Заменить "' .. search_term .. '" на: ')
	if replacement == "" then
		print("Замена отменена.")
		return
	end

	local flags = ""
	if scope == "all" then
		flags = "g"
	end

	local escaped_search_term = vim.fn.escape(search_term, "/")
	local cmd_prefix = "%"
	if scope == "line" then
		cmd_prefix = ""
	end

	vim.cmd(cmd_prefix .. "s/" .. escaped_search_term .. "/" .. replacement .. "/" .. flags)
end

-- Заменить все вхождения последнего поиска
vim.keymap.set("n", "<leader>ra", function()
	InteractiveReplace("all")
end, {
	noremap = true,
	silent = true,
	desc = "Заменить все вхождения последнего поиска",
})
-- Заменить на текущей строке
vim.keymap.set("n", "<leader>rl", function()
	InteractiveReplace("line")
end, { noremap = true, silent = true, desc = "Заменить на текущей строке" })
