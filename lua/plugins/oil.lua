local git_ignored = nil
local git_ignored_cwd = nil

local function apply_git_ignored_files(result)
	local files, dirs, full_paths = {}, {}, {}

	if result.code == 0 then
		for line in vim.gsplit(result.stdout or "", "\n", { plain = true, trimempty = true }) do
			-- Store full paths for checking parent directories
			local path = line:gsub("/$", "")
			full_paths[path] = true

			-- Store directory paths separately
			if line:sub(-1) == "/" then
				-- Get just the directory name, not the full path
				dirs[vim.fn.fnamemodify(path, ":t")] = true
			else
				-- Get just the filename, not the full path
				files[vim.fn.fnamemodify(path, ":t")] = true
			end
		end
	end

	git_ignored = { files = files, dirs = dirs, full_paths = full_paths }

	-- Re-render visible oil buffers with the fresh ignore information
	vim.schedule(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].ft == "oil" then
				pcall(function()
					require("oil.view").rerender_all_oil_buffers({ refetch = false })
				end)
			end
		end
	end)
end

-- Kick off (or refresh) the async git ignored-files computation. Never blocks.
local function request_git_ignored_files(force)
	local cwd = vim.fn.getcwd()
	if git_ignored == "pending" and git_ignored_cwd == cwd then
		return
	end
	if not force and type(git_ignored) == "table" and git_ignored_cwd == cwd then
		return
	end

	git_ignored_cwd = cwd
	git_ignored = "pending"
	vim.system({
		"git",
		"ls-files",
		"--others",
		"--ignored",
		"--exclude-standard",
		"--directory",
	}, {
		cwd = cwd,
		text = true,
	}, apply_git_ignored_files)
end

return {
	"oil.nvim",
	for_cat = "oil",
	priority = 1000,
	lazy = false,
	after = function()
		vim.g.loaded_netrwPlugin = 1
		require("oil").setup({
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, bufnr)
					if name == ".." then
						return true
					end

					-- Check if the file is .git directory
					if name == ".git" then
						return true
					end

					return false
				end,
				-- Customize the highlight group for the file name
				highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
					-- Skip parent directory entry
					if entry.name == ".." then
						return nil
					end

					local ignored = git_ignored

					if type(ignored) == "table" and (ignored.files[entry.name] or ignored.dirs[entry.name]) then
						return "OilGitIgnored" -- Gray out git-ignored files
					end

					-- Get the current directory being viewed in Oil
					local current_dir = require("oil").get_current_dir()
					if not current_dir then
						return nil
					end

					-- Check if any parent directory is git-ignored
					local path_to_check = vim.fn.fnamemodify(vim.fs.normalize(current_dir .. entry.name), ":.")

					-- Check all parent directories
					local path_parts = {}
					local full_paths = type(ignored) == "table" and ignored.full_paths or {}
					for part in vim.gsplit(path_to_check, "/", { plain = true }) do
						table.insert(path_parts, part)
						local partial_path = table.concat(path_parts, "/")
						if full_paths[partial_path] then
							return "OilGitIgnored"
						end
					end

					return nil -- Use default highlighting for non-ignored files
				end,
			},
			keymaps = {
				["gd"] = {
					desc = "Toggle file detail view",
					callback = function()
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
			},
		})

		local refresh = require("oil.actions").refresh
		local original_refresh = refresh.callback
		refresh.callback = function(...)
			-- Refresh the list of git ignored files (async, non-blocking)
			request_git_ignored_files(true)

			-- Call the original refresh function
			original_refresh(...)
		end

		-- Create custom highlight group for git ignored files
		vim.api.nvim_set_hl(0, "OilGitIgnored", { link = "Comment" })

		-- Reset the hidden files highlight to make them appear normal
		vim.api.nvim_set_hl(0, "OilFileHidden", {
			link = "OilFile",
		}) -- For hidden files
		vim.api.nvim_set_hl(0, "OilDirHidden", {
			link = "Directory",
		}) -- For hidden files

		vim.keymap.set("n", "-", function()
			require("oil").open()
		end, { noremap = true, desc = "Open current file directory" })
		vim.keymap.set("n", "_", function()
			require("oil").open(vim.fn.getcwd())
		end, { noremap = true, desc = "Open current working directory" })

		-- Warm up the git ignored files list asynchronously so the first oil
		-- render is never blocked by `git ls-files`
		request_git_ignored_files()
	end,
}
