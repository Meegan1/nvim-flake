local M = {}

-- lze handler for nix categories
M.for_cat = {
	spec_field = "for_cat",
	set_lazy = false,
	modify = function(plugin)
		if type(plugin.for_cat) == "table" and plugin.for_cat.cat ~= nil then
			if vim.g[ [[nixCats-special-rtp-entry-nixCats]] ] ~= nil then
				plugin.enabled = nixCats(plugin.for_cat.cat) or false
			else
				plugin.enabled = plugin.for_cat.default
			end
		else
			plugin.enabled = nixCats(plugin.for_cat) or false
		end
		return plugin
	end,
}

-- lze handler for nix category value matching
M.for_cat_value = {
	spec_field = "for_cat_value",
	set_lazy = false,
	modify = function(plugin)
		if plugin.for_cat == nil then
			return plugin
		end

		if plugin.for_cat_value == nil then
			return plugin
		end

		local cat_value = nixCats(plugin.for_cat)
		if cat_value == plugin.for_cat_value then
			plugin.enabled = true
		else
			plugin.enabled = false
		end

		return plugin
	end,
}

return M
