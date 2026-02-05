return {
	"zk-nvim",
	for_cat = "zk",
	after = function()
		require("zk").setup({
			picker = "fzf_lua",
		})

		-- Create a new note after asking for its title.
		vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", {
			desc = "Create a new Zk note",
			noremap = true,
			silent = false,
		})

		-- Create a new daily note.
		vim.keymap.set("n", "<leader>zd", function()
			require("zk").new({
				dir = "daily",
				date = "today",
				group = "daily",
				title = os.date("%Y-%m-%d"),
			})
		end, {
			desc = "Create a new Zk daily note",
			noremap = true,
			silent = false,
		})

		-- Open notes.
		vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", {
			desc = "Open Zk notes",
			noremap = true,
			silent = false,
		})
		-- Open notes associated with the selected tags.
		vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", {
			desc = "Open Zk notes by tags",
			noremap = true,
			silent = false,
		})

		-- Search for the notes matching a given query.
		vim.keymap.set(
			"n",
			"<leader>zf",
			"<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
			{
				desc = "Search Zk notes",
				noremap = true,
				silent = false,
			}
		)
		-- Search for the notes matching the current visual selection.
		vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>", {
			desc = "Search Zk notes (visual)",
			noremap = true,
			silent = false,
		})
	end,
}
