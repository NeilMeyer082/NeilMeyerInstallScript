-- ===== Basic Neovim Settings =====

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- UI
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

-- Behavior
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Faster updates
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Clipboard (system clipboard)
vim.opt.clipboard = "unnamedplus"

-- Mouse support (useful in terminals)
vim.opt.mouse = "a"

-- Leader key
vim.g.mapleader = " "

-- ===== Keybindings =====

-- Quick save
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- Quit
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Clear search highlight
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

