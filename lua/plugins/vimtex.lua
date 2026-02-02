return {

	"vimtex",
	for_cat = "latex",
	lazy = true,
	ft = { "tex" },
	after = function()
		-- and sioyek as the default viewer
		vim.g.vimtex_view_method = "sioyek"
		vim.g.vimtex_view_general_options = "-reuse-instance"
		vim.g.vimtex_view_forward_search_width = 1
	end,
}
