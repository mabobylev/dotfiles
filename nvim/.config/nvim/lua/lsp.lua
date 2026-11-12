require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "marksman", "gopls", "rust_analyzer", "clangd" },
    automatic_enable = false,
})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = "rounded", source = true },
})

local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("blink.cmp").get_lsp_capabilities()
)
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    -- fall back to the file's directory so lone files outside a project still get a workspace
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root = fname ~= "" and vim.fs.root(bufnr, { ".luarc.json", ".emmyrc.json", ".git" })
        on_dir(root or vim.fs.dirname(fname))
    end,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
            telemetry = { enable = false },
        },
    },
})

-- .h files get filetype "c" in Neovim, so "c"/"cpp" covers .c/.h/.cpp
vim.lsp.config("clangd", {
    filetypes = { "c", "cpp" },
})

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
    "clangd",
})
