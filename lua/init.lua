require("config.options")
require("config.yank")

require("lze").register_handlers(require("utils.lzeCats").for_cat)
require("lze").register_handlers(require("utils.lzeCats").for_cat_value)
require("lze").register_handlers(require("lzextras").lsp)

require("lze").load("plugins")
