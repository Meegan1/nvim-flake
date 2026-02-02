return {

	"multicursors.nvim",
	for_cat = "multicursor",
	event = "DeferredUIEnter",
	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	keys = {
		{
			mode = { "v", "n" },
			"gb",
			function()
				vim.cmd("MCstart")
			end,
			desc = "Create a selection for selected text or word under the cursor",
		},
	},
	after = function()
		require("multicursors").setup({
			updatetime = 0,
		})

		-- Set the highlight group for the cursor
		vim.api.nvim_set_hl(0, "MultiCursor", { bg = "Grey40", fg = "black" })
		vim.api.nvim_set_hl(0, "MultiCursorMain", { bg = "Grey60", fg = "black" })
	end,
}
