return {
	"kulala.nvim",
	for_cat = "kulala",
	ft = { "http", "rest" },
	after = function()
		require("kulala").setup({
			-- your configuration comes here
			global_keymaps = true,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		})
	end,
}
