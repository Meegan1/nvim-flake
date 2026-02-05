return {
	"zk-nvim",
	for_cat = "zk",
	after = function()
		require("zk").setup()
	end,
}
