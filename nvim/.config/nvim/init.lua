pcall(function()
    require("vim._core.ui2").enable({})
end)

require("options")
require("keymaps")
require("commands")
require("pack")
require("treesitter")
require("lsp")

-- Тема приходит из ~/.local/state/theme/nvim.lua, который пишет theme-apply.
local function apply_theme()
    local ok, t = pcall(dofile, vim.fn.expand("~/.local/state/theme/nvim.lua"))
    if not ok or type(t) ~= "table" then
        return
    end
    vim.o.background = t.background or "dark"
    if not pcall(vim.cmd.colorscheme, t.colorscheme) then
        vim.notify("Нет colorscheme: " .. tostring(t.colorscheme), vim.log.levels.WARN)
    end
end

_G.ApplyTheme = apply_theme
apply_theme()

local ok, matugen = pcall(require, 'matugen')
if ok then matugen.setup() end
