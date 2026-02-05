return {
	"zk-nvim",
	for_cat = "zk",
	after = function()
		require("zk").setup({
			picker = "fzf_lua",
		})
	end,
}
