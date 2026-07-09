local opt = vim.opt

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

opt.number = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.undofile = true

-- tabs & indentation
opt.tabstop = 4       -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4    -- 4 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.relativenumber = true
