-- Set leader key to space
vim.g.mapleader = " "

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- set numbers enabled
vim.opt.number = true
-- disable relative numbers
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.undofile = true

-- spell check (deferred: enabling spell loads en_us.spl, ~12ms at startup)
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en_us"
	end,
})

-- splitright and splitbelow
vim.opt.splitright = true
vim.opt.splitbelow = true
