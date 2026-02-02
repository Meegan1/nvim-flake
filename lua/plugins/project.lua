return {
	"project.nvim",
	for_cat = "project",
	after = function()
		require("project").setup({
			patterns = {
				".git",
			},
			fzf_lua = {
				enabled = nixCats("fzf-lua"),
			},
		})

		if nixCats("fzf-lua") then
			local fzf_lua = require("fzf-lua")

			vim.keymap.set("n", "<leader>fp", function()
				local history = require("project.utils.history")
				fzf_lua.fzf_exec(function(cb)
					local results = history.get_recent_projects()
					for _, e in ipairs(results) do
						cb(e)
					end
					cb()
				end, {
					actions = {
						["default"] = {
							function(selected)
								fzf_lua.files({ cwd = selected[1] })
							end,
						},
						["ctrl-d"] = {
							function(selected)
								history.delete_project({ value = selected[1] })
							end,
							fzf_lua.actions.resume,
						},
					},
				})
			end, {
				desc = "fzf-lua: projects",
			})
		end
	end,
}
