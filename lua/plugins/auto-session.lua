return {
	"auto-session",
	for_cat = "auto-session",
	lazy = false,
	priority = 20000,
	after = function()
		-- set session options
		vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"

		local load_oil = function()
			if nixCats("oil") ~= true then
				return
			end

			require("oil")
		end

		-- If no directory is provided, don't auto restore the session
		local auto_restore_enabled = (function()
			local argv = vim.fn.argv()
			if #argv == 0 then
				return false
			end

			local path = argv[1]
			if path == nil or path == "" then
				return false
			end

			return true
		end)()

		local function close_all_floating_wins()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
			end
		end

		require("auto-session").setup({
			enabled = true,
			auto_restore = auto_restore_enabled,
			auto_save = true,
			suppressed_dirs = { "~/", "~/Documents/Projects", "~/Downloads", "/" },
			bypass_save_filetypes = { "alpha" },
			legacy_cmds = false,

			-- only save session if we are inside a git repo
			auto_create = function()
				local cmd = "git rev-parse --is-inside-work-tree"
				return vim.fn.system(cmd) == "true\n"
			end,

			pre_save_cmds = {
				close_all_floating_wins,
				function()
					vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
				end,
				function()
					if nixCats("overseer") ~= true then
						return
					end

					require("overseer.window").close()

					local tasks = require("overseer.task_list").list_tasks()
					local cmds = {}
					for _, task in ipairs(tasks) do
						local json = vim.json.encode(task:serialize())
						-- For some reason, vim.json.encode encodes / as \/.
						json = string.gsub(json, "\\/", "/")
						-- Escape single quotes so we can put this inside single quotes
						json = string.gsub(json, "'", "\\'")
						table.insert(
							cmds,
							string.format("lua require('overseer').new_task(vim.json.decode('%s')):start()", json)
						)
					end
					return cmds
				end,
			},

			pre_restore_cmds = {
				load_oil,
				-- Get rid of all previous tasks when restoring a session
				function()
					vim.notify(
						"Loading oil.nvim as part of session restore",
						vim.log.levels.INFO,
						{ title = "auto-session" }
					)
					if nixCats("overseer") ~= true then
						return
					end

					for _, task in ipairs(require("overseer").list_tasks({})) do
						task:dispose(true)
					end
				end,
			},

			post_restore_cmds = {
				function()
					if nixCats("overseer") ~= true then
						return
					end

					for _, task in ipairs(require("overseer").list_tasks({})) do
						task:dispose(true)
					end
				end,
				"stopinsert", -- Stop insert mode after restoring session
			},

			no_restore_cmds = {
				load_oil,
			},

			-- Save quickfix list and open it when restoring the session
			save_extra_cmds = {
				function()
					local qflist = vim.fn.getqflist()
					-- return nil to clear any old qflist
					if #qflist == 0 then
						return nil
					end
					local qfinfo = vim.fn.getqflist({ title = 1 })

					for _, entry in ipairs(qflist) do
						-- use filename instead of bufnr so it can be reloaded
						entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
						entry.bufnr = nil
					end

					local setqflist = "call setqflist(" .. vim.fn.string(qflist) .. ")"
					local setqfinfo = 'call setqflist([], "a", ' .. vim.fn.string(qfinfo) .. ")"
					return { setqflist, setqfinfo, "copen" }
				end,
			},

			session_lens = {
				load_on_setup = true,
				picker_opts = {
					border = true,
					previewer = false,
				},
				mappings = {
					-- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
				},
			},
		})
	end,
}
