return {
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		priority = 50,
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(plugin)
			vim.lsp.config("*", {
				-- capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Your on_attach function should set buffer-local lsp related settings
					local nmap = function(keys, func, desc)
						if desc then
							desc = "LSP: " .. desc
						end
						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
					end
					nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					-- etc...
				end,
			})
		end,
	},
	{
		"lazydev.nvim",
		for_cat = "lsp",
		ft = "lua",
		after = function()
			require("lazydev").setup({
				library = {
					{
						path = nixCats.nixCatsPath and nixCats.nixCatsPath .. "/lua" or nil,
						words = { "nixCats" },
					},
				},
			})
		end,
	},
	{
		"lua_ls",
		lsp = {
			-- if you include a filetype, it doesnt call lspconfig for the list of filetypes (faster)
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					workspace = {
						checkThirdParty = false,
						library = {
							-- '${3rd}/luv/library',
							-- unpack(vim.api.nvim_get_runtime_file('', true)),
						},
					},
					completion = {
						callSnippet = "Replace",
					},
					telemetry = { enabled = false },
				},
			},
		},
	},
}
