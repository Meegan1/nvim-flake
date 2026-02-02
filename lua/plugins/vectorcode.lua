return {
	"vectorcode.nvim",
	for_cat = "vectorcode",
	dep_of = { "codecompanion.nvim" },
	after = function()
		require("vectorcode").setup()
	end,
}
