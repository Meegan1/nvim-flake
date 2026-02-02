return {
	{
		"mini.ai",
		for_cat = "textobjects",
		after = function()
			require("mini.ai").setup()
		end,
	},
	{
		"mini.move",
		for_cat = "move",
		after = function()
			require("mini.move").setup({
				mappings = {
					left = "<A-h>",
					down = "<A-j>",
					up = "<A-k>",
					right = "<A-l>",

					line_left = "<A-h>",
					line_down = "<A-j>",
					line_up = "<A-k>",
					line_right = "<A-l>",
				},
			})
		end,
	},
}
