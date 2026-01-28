return {
	{
		"nvim-ts-context-commentstring",
		for_cat = "comment",
		dep_of = "comment.nvim",
		after = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"comment.nvim",
		for_cat = "comment",
		after = function()
			local pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

			require("Comment").setup({
				pre_hook = pre_hook,
				toggler = {
					line = "gcc",
					block = "gCC",
				},
				opleader = {
					line = "gc",
					block = "gC",
				},
			})
		end,
	},
}
