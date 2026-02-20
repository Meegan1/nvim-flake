return {
	{
		"hydra.nvim",
		for_cat = { "hydra" },
		after = function()
			local Hydra = require("hydra")

			if nixCats("window-management") then
				local smart_splits = require("smart-splits")

				Hydra({
					name = "Resize windows",
					mode = { "n", "t" },
					body = "<A-w>",
					hint = [[Resize windows]],

					heads = {
						{
							"h",
							function()
								smart_splits.resize_left()
							end,
							{ desc = "Resize left" },
						},
						{
							"l",
							function()
								smart_splits.resize_right()
							end,
							{ desc = "Resize right" },
						},
						{
							"k",
							function()
								smart_splits.resize_up()
							end,
							{ desc = "Resize up" },
						},
						{
							"j",
							function()
								smart_splits.resize_down()
							end,
							{ desc = "Resize down" },
						},
					},
				})
			end
		end,
	},
}
