return {
	"render-markdown.nvim",
	for_cat = "markdown",
	after = function()
		require("render-markdown").setup({

			heading = {
				enabled = false,
			},
			code = {
				language_name = false,
			},
			sign = {
				enabled = false,
			},
		})
	end,
}
