return {
	{
		"yaml-schema-crds",
		for_cat = "yaml-schema-crds",
		lazy = false,
		-- override load to prevent trying to load from plugin path
		load = function() end,
		after = function()
			require("modules.yaml-schema-crds").setup()
		end,
	},
}
