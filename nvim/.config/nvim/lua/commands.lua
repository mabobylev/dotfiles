vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
    local plugins = vim.split(opts.args, "%s+", { trimempty = true })
    vim.pack.update(#plugins > 0 and plugins or nil)
end, { nargs = "*", desc = "Update all plugins or the named ones" })

-- Show the starter only in a fresh, empty tab, not for `:tabnew file`.
vim.api.nvim_create_autocmd("TabNewEntered", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
            require("mini.starter").open()
        end
    end,
})
