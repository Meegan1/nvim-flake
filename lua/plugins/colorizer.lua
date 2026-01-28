return {
	"nvim-colorizer.lua",
	event = { "BufReadPre" },
	after = function()
		require("colorizer").setup({
			user_default_options = {
				names = false,
				tailwind = "lsp",
				tailwind_opts = {
					update_names = true,
				},
				mode = "virtualtext",
				virtualtext = "■",
				virtualtext_inline = "before",
				always_update = true,
			},
		})
	end,
}
