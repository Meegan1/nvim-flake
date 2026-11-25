return {
	"codediff.nvim",
	for_cat = "codediff",
	-- The native libvscode-diff library is bundled into the plugin package by
	-- the overlay in nix/default.nix (the plugin's runtime auto-installer can
	-- never write into the read-only Nix store), so stop it from trying.
	before = function()
		vim.env.VSCODE_DIFF_NO_AUTO_INSTALL = "1"
	end,
	after = function() end,
}
