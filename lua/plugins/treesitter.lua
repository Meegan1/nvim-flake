return {
	"nvim-treesitter",
	for_cat = "treesitter",
	priority = 10000,
	lazy = false,
	after = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
				if lang and pcall(vim.treesitter.language.add, lang) then
					pcall(vim.treesitter.start)
				end
			end,
		})

		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		require("nvim-treesitter").setup()

		-- Treesitter plugins to ensure are installed
		require("nvim-treesitter").install({
			"typescript",
			"javascript",
			"tsx",
			"html",
			"lua",
			"json",
			"yaml",
			"css",
			"scss",
			"graphql",
			"bash",
			"liquid",
			"vue",
			"markdown",
			"markdown_inline",
			"regex",
			"gotmpl",
			"helm",
			"php",
			"diff",
			"nix",
			"blade",
			"twig",
			"astro",
		})

		-- Add support for gotmpl filetype and helm templates
		vim.filetype.add({
			extension = {
				gotmpl = "gotmpl",
			},
			pattern = {
				[".*/templates/.*%.tpl"] = "helm",
				[".*/templates/.*%.ya?ml"] = "helm",
				["helmfile.*%.ya?ml"] = "helm",
			},
		})

		-- Add support for the blade filetype
		vim.filetype.add({
			extension = {
				blade = "blade",
			},
			pattern = {
				["%.blade%.php"] = "blade",
			},
		})
	end,
}
