return {
  "nvim-surround",
  for_cat = "surround",
  event = "DeferredUIEnter",
  after = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
  end
}
