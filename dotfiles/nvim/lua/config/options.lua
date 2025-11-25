local opt = vim.opt
local data_path = vim.fn.stdpath("data")

-- ===== Интерфейс =====
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = false
opt.signcolumn = "yes"

-- ===== Отступы =====
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.autoindent = true

-- ===== Цвета =====
opt.termguicolors = true
opt.background = "dark"

-- ===== Буфер и клипборд =====
opt.clipboard = "unnamedplus"
opt.undofile = true

-- ===== Поиск =====
opt.ignorecase = true
opt.smartcase = true

-- ===== swap/undo/backup =====
for _, dir in ipairs({ "swap", "undo", "backup" }) do
	local path = data_path .. "/" .. dir
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end
end
opt.directory = data_path .. "/swap//"
opt.backupdir = data_path .. "/backup//"
opt.undodir = data_path .. "/undo//"

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = false

-- ===== Дополнительно =====
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.backspace = "start,eol,indent"
vim.opt.isfname:append("@-@")
vim.opt.hlsearch = true

-- Поиск
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Подсказки для командной строки
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
