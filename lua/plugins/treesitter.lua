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
	end,
}
