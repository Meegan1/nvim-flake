return {
	"catppuccin-nvim",
	for_cat = "colorscheme",
	for_cat_value = "catppuccin",
	priority = 1000, -- Ensure it loads first
	lazy = false,
	after = function()
		require("catppuccin").setup({
			integrations = {
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				mason = true,
				gitsigns = true,
				treesitter = true,
				noice = true,
				nvim_surround = true,
				neotree = true,
				barbar = true,
				flash = true,
				which_key = true,
				neogit = true,
				dadbod_ui = true,
				notify = true,
				mini = true,
				snacks = true,
				fzf = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")

		if nixCats("noice") then
			local C = require("catppuccin.palettes").get_palette()

			vim.api.nvim_set_hl(0, "SnacksIndent", { fg = C.surface0 })
			vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#3b4261" })
		end
	end,
}
