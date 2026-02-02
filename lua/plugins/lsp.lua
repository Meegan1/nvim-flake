local ESC = vim.api.nvim_replace_termcodes("<esc>", true, true, true)

local on_attach = function(client, bufnr)
	-- Your on_attach function should set buffer-local lsp related settings
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gh", vim.lsp.buf.hover, "Show LSP Info")
	nmap("gd", vim.lsp.buf.definition, "Open LSP Definition")
	nmap("gi", vim.lsp.buf.implementation, "Open LSP Implementation")
	nmap("gr", vim.lsp.buf.references, "Show LSP References")
	nmap("go", vim.lsp.buf.type_definition, "Open Type Definition")
	nmap("gs", vim.lsp.buf.signature_help, "Open Signature Help")

	-- bind <Esc> to close hover windows globally
	vim.on_key(function(key)
		if key == ESC and (vim.fn.mode() == "n" or vim.fn.mode() == "v") then
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
			end
		end
	end)
	-- etc...
end

return {
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		priority = 50,
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function()
			vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open LSP diagnostic float" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous LSP Diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next LSP Diagnostic" })

			vim.lsp.config("*", {
				-- capabilities = capabilities,
				on_attach = on_attach,
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
		for_cat = "lsp",
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
	{
		"ts_ls",
		for_cat = "lsp",
		lsp = {
			init_options = { hostInfo = "neovim" },
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			handlers = {
				-- handle rename request for certain code actions like extracting functions / types
				["_typescript.rename"] = function(_, result, ctx)
					local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
					vim.lsp.util.show_document({
						uri = result.textDocument.uri,
						range = {
							start = result.position,
							["end"] = result.position,
						},
					}, client.offset_encoding)
					vim.lsp.buf.rename()
					return vim.NIL
				end,
			},
			commands = {
				["editor.action.showReferences"] = function(command, ctx)
					local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
					local file_uri, position, references = unpack(command.arguments)

					local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
					vim.fn.setqflist({}, " ", {
						title = command.title,
						items = quickfix_items,
						context = {
							command = command,
							bufnr = ctx.bufnr,
						},
					})

					vim.lsp.util.show_document({
						uri = file_uri,
						range = {
							start = position,
							["end"] = position,
						},
					}, client.offset_encoding)

					vim.cmd("botright copen")
				end,
			},
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				-- Enable inlay hints if nvim version is 0.10 or higher
				if vim.fn.has("nvim-0.10") == 1 then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

				-- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
				-- `vim.lsp.buf.code_action()` if specified in `context.only`.
				vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
					local source_actions = vim.tbl_filter(function(action)
						return vim.startswith(action, "source.")
					end, client.server_capabilities.codeActionProvider.codeActionKinds)

					vim.lsp.buf.code_action({
						context = {
							diagnostics = {},
							only = source_actions,
						},
					})
				end, {})

				vim.keymap.set("n", "<leader>ir", function()
					vim.lsp.buf.code_action({
						context = {
							diagnostics = {},
							---@diagnostic disable-next-line: assign-type-mismatch
							only = { "source.removeUnused.ts" },
						},
						apply = true,
					})
				end, {
					desc = "Remove unused imports",
					buffer = bufnr,
				})

				vim.keymap.set("n", "<leader>if", function()
					vim.lsp.buf.code_action({
						context = {
							diagnostics = {},
							---@diagnostic disable-next-line: assign-type-mismatch
							only = { "source.addMissingImports.ts" },
						},
						apply = true,
					})
				end, {
					desc = "Fix imports",
					buffer = bufnr,
				})
			end,
		},
	},
	{
		"yamlls",
		for_cat = "lsp",
		lsp = {
			settings = {
				yaml = {
					schemas = {
						kubernetes = "templates/**",
						["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
						["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
						["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
						["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
						["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
					},
				},
			},
			root_markers = { ".git", "package.json", "kustomization.yaml", "Chart.yaml" },
		},
	},
	{
		"jsonls",
		for_cat = "lsp",
		lsp = {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
			root_markers = { ".git", "package.json" },
		},
	},
}
