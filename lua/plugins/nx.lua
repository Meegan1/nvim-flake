return {
	"nx.nvim",
	for_cat = "nx",
	keys = {
		{ "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
		{ "<leader>ng", "<cmd>Telescope nx generators<CR>", desc = "nx generators" },
	},
	after = function()
		require("nx").setup({
			nx_cmd_root = "bun nx",
		})
	end,
}
