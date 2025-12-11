-- Custom autocommands for entering files, highlighting, bad whitespace, etc.

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Strip trailing whitespace that matches patterns for python, rust, markdown, etc
-- during file write and file read
local strip_whitespace = vim.api.nvim_create_augroup("strip_whitespace", { clear = true })

-- All other files formatting before write
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Strip trailing whitespace before writing buffer to disk",
	group = strip_whitespace,
	pattern = { "*" },
	callback = function()
		vim.cmd([[%s`\v\s\+$``e]])
	end,
})

-- Markdown (skip formatting at write)
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Strip trailing whitespace before writing buffer to disk",
	group = strip_whitespace,
	pattern = { "markdown" },
	callback = function() end,
})

-- Rust formatting before write
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Strip trailing whitespace before writing buffer to disk",
	group = strip_whitespace,
	pattern = { "rust" },
	callback = function()
		vim.cmd([[%s`\v^(\s*//[^/!]{-}\|\s*[^/]{-}\|\n)(\s+)$`\1`ge]])
	end,
})

-- Any file
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
	desc = "Strip trailing whitespace on buffer read or new file",
	group = strip_whitespace,
	pattern = { "*" },
	callback = function(args)
		vim.keymap.set("n", "<F4>", ":let _s=@/|:%s`\\v\\s+$``ge|:let @/=_s|<CR>")
	end,
})

-- Rust formatting
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWinEnter" }, {
	desc = "Strip trailing whitespace on buffer read or new file",
	group = strip_whitespace,
	pattern = { "rust" },
	callback = function()
		vim.keymap.set(
			"n",
			"<F4>",
			":let _s=@/|:%s`\\v^(\\s*//[^/!]{-}\\|\\s*[^/]{-}\\|\\n)(\\s+)$`\\1`ge|:let @/=_s|<CR>"
		)
	end,
})

local set_ft_opts = vim.api.nvim_create_augroup("set_ft_opts", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
	group = set_ft_opts,
	pattern = { "*.py", "*.pyw" },
	callback = function()
		vim.opt = {
			expandtab = true,
			autoread = true,
			tabstop = 4,
			softtabstop = 4,
			shiftwidth = 4,
			textwidth = 99,
			fileformat = "unix",
			foldmethod = "indent",
		}
		-- vim.keymap.set("n", "<F4>", ":let _s=@/<Bar>:%s`\vs+$``ge<Bar>:let @/=_s<Bar><CR>")
		vim.cmd([[match BadWhitespace /\s\+$/]])
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = set_ft_opts,
	pattern = { "*.rs" },
	callback = function()
		vim.opt = {
			autoread = true,
			fileformat = "unix",
		}
		-- vim.keymap.set("n", "<F4>", ":let _s=@/<Bar>:%s`\v^(\s*//[^/!]{-}\|\s*[^/]{-}\|\n)(\s+)$`\1`ge<Bar>:let @/=_s<Bar><CR>")
		vim.cmd([[match BadWhitespace /\s\+$/]])
	end,
})

-- vim: ts=2 sts=2 sw=2 et
