return {
	"typst-preview.nvim",
	for_cat = "typst",
	ft = "typst",
	after = function()
		require("typst-preview").setup({})
	end,
}
