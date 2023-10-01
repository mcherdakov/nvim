-- enable line numbers
vim.wo.number = true 

-- relative line numbers
vim.wo.relativenumber = true

-- sync clipboard between os and nvim
vim.o.clipboard = 'unnamedplus'

-- Set highlight on search
vim.o.hlsearch = false

-- line wrap stays with same indent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- completion options:
-- menuone - show select menu even if there is only one item
-- noselect - no selection by default
vim.o.completeopt = 'menuone,noselect'

-- use 24-bit colors from terminal
vim.o.termguicolors = true

vim.cmd([[ set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz ]])
