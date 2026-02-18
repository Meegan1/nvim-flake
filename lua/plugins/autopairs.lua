return {
	{
		"nvim-ts-autotag",
		for_cat = "autopairs",
		event = "InsertEnter",
		after = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"nvim-autopairs",
		for_cat = "autopairs",
		event = "InsertEnter",
		after = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},
}
