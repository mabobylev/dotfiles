pcall(function()
    require("vim._core.ui2").enable({})
end)

require("options")
require("keymaps")
require("commands")
require("pack")
require("treesitter")
require("lsp")

vim.cmd.colorscheme("tokyonight")
