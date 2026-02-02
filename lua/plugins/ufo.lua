return {
	{
		"promise-async",
		for_cat = "ufo",
		dep_of = { "nvim-ufo" },
	},
	{
		"nvim-ufo",
		for_cat = "ufo",
		after = function()
			vim.opt.foldcolumn = "0"
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
			vim.opt.foldenable = true

			vim.keymap.set("n", "zO", require("ufo").openAllFolds)
			vim.keymap.set("n", "zC", require("ufo").closeAllFolds)

			require("ufo").setup()
		end,
	},
}
