require("config.options")
require("config.yank")
require("config.keymaps")
require("config.exrc")

require("lze").register_handlers(require("utils.lzeCats").for_cat)
require("lze").register_handlers(require("utils.lzeCats").for_cat_value)

require("lze").load("plugins")
