local treesitter = require("nvim-treesitter")

local ensure_installed = {
    "go",
    "rust",
    "typescript",
    "javascript",
    "tsx",
    "html",
    "css",
    "json",
    "bash",
    "http",
    "dockerfile",
    "lua",
    "markdown",
    "markdown_inline",
    "yaml",
    "toml",
    "python",
    "cpp",
}

treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
            return
        end

        if not pcall(vim.treesitter.language.add, lang) then
            return
        end

        pcall(vim.treesitter.start, buf, lang)

        local ok, indents = pcall(vim.treesitter.query.get, lang, "indents")
        if ok and indents then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
