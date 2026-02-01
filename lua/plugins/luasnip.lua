-- todo: convert to new lze plugin format
return {
	"LuaSnip",
	for_cat = "snippets",
	version = "v2.*",
	run = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function(_, opts)
		require("luasnip").setup(opts)
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
