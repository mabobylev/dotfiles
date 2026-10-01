require("mason").setup()

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities       = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    workspace = {
        checkThirdParty = false,
        library = {
            vim.env.VIMRUNTIME
        },
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
                telemetry = { enable = { false } },
            },
        },
    },
})

vim.lsp.config('clangd', {
    cmd = { 'clangd' },
    filtype = { 'c', 'h' },
})

vim.lsp.enable({
    "lua_ls",
    "marksman",
    "gopls",
    "rust_analyzer",
    "clangd",
})
