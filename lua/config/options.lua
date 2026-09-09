vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.incsearch = true -- match with strings as you search
vim.opt.hlsearch = false -- persist highlight on searched word

vim.opt.ignorecase = true -- search ignoring case
vim.opt.smartcase = true -- ignore case unless capital letter is used

vim.opt.scrolloff = 8 -- minimum number of lines above or below cursor

vim.opt.tabstop = 4 -- length of tab char
vim.opt.shiftwidth = 4 -- indent length
vim.opt.expandtab = true -- converts tab into spaces
vim.cmd("filetype plugin indent on") -- filetype detects the file type
-- plugin enables the filetype specific plugins to be enabled
-- indent allows the specific file type indentations
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.signcolumn = "auto"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.clipboard = "unnamedplus" -- same clipboard for laptop and vim

vim.g.netrw_liststyle = 1
vim.o.background = dark

vim.diagnostic.config({ float = { focusable = false } })


