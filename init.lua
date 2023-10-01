-- this must be set before any plugins are required to set correct leader
vim.g.mapleader = ' '

require('plugins')
require('options')
require('ui')
require('fuzz')
require('keymaps')
require('explorer')
require('ts')
require('lsp')
