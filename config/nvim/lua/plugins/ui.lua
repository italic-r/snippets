return {
	"romgrk/barbar.nvim",
	lazy = false,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		{ "lewis6991/gitsigns.nvim", opts = {} },
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		animation = false,
		auto_hide = false,
		tabpages = true,
		closable = true,
		clickable = true,
		exclude_ft = { "javascript" },
		exclude_name = { "package.json" },
		highlight_visible = true,
		highlight_alternate = false,
		highlight_inactive_file_icons = false,
		hide = { extensions = true, inactive = false },
		icons = {
			enabled = true,
			diagnostics = {
				[vim.diagnostic.severity.ERROR] = { enabled = true, icon = "" },
				[vim.diagnostic.severity.WARN] = { enabled = false },
				[vim.diagnostic.severity.INFO] = { enabled = false },
				[vim.diagnostic.severity.HINT] = { enabled = true },
			},
			separator = { left = "▎" },
			inactive = {
				separator = { left = "▎" },
			},
			gitsigns = {
				added = { enabled = true, icon = "+" },
				changed = { enabled = true, icon = "~" },
				deleted = { enabled = true, icon = "-" },
			},
			filetype = { custom_colors = false, enabled = true },
			modified = { button = "●" },
			pinned = { button = "󰐃", filename = true },
		},
		insert_at_start = false,
		insert_at_end = false,
		maximum_padding = 4,
		minimum_padding = 1,
		maximum_length = 20,
		semantic_letters = true,
		letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
		no_name_title = nil,
	},

	keys = {
		{ "<A-,>", "<Cmd>BufferPrevious<CR>" },
		{ "<A-.>", "<Cmd>BufferNext<CR>" },
		{ "<A-S-,>", "<Cmd>BufferMovePrevious<CR>" },
		{ "<A-S-.>", "<Cmd>BufferMoveNext<CR>" },
		{ "<A-S-p>", "<Cmd>BufferPin<CR>" },
		{ "<A-c>", "<Cmd>BufferClose<CR>" },
		--[[ Extra barbar commands
      Wipeout buffer
        :BufferWipeout
      Close commands
        :BufferCloseAllButCurrent
        :BufferCloseAllButVisible
        :BufferCloseAllButPinned
        :BufferCloseAllButCurrentOrPinned
        :BufferCloseBuffersLeft
        :BufferCloseBuffersRight

      Magic buffer-picking mode
        nnoremap <silent> <A-p> <Cmd>BufferPick<CR>
        nnoremap <silent> <A-p> <Cmd>BufferPickDelete<CR>
    --]]
	},
}

-- vim: ts=2 sts=2 sw=2 et
