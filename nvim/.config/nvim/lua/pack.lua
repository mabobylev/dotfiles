vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

--- tokyonight theme ----
require("tokyonight").setup({})

--- lualine setup ----
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        -- theme  = "tokyonight",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
})
--- mini traisspace ----
require("mini.trailspace").setup()
vim.keymap.set("n", "<leader>tw", function()
    require("mini.trailspace").trim()
end, { desc = "Trim trailing whitespace" })

--- mini buffers map ----
-- require('mini.map').setup()

--- mini tabline ----
require("mini.tabline").setup()

--- mini hipatterns ----
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

--- mini pairs ----
require("mini.pairs").setup()

--- mini files ----
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", function()
    require("mini.files").open()
end, { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

---- mini notify ----
require("mini.notify").setup({
    -- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

--- mini starter ---
require("mini.starter").setup()

--- mini surround ---
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |

--- completion (blink.cmp) ---
require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "normal" },
    completion = {
        menu = { auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        -- mini.pairs already closes brackets
        accept = { auto_brackets = { enabled = false } },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    snippets = { preset = "mini_snippets" },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
    },
})

--- mini snippets ---
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })

--- mini diff and fugitive ---
local MiniDiff = require("mini.diff")
MiniDiff.setup({
    source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tab Git<cr>", { desc = "Fugitive status in a new tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })

--- fzf ---
local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        },
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"] = actions.file_edit_or_qf,
        },
    },
})

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "FZF - find files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "FZF - live grep" })
vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", fzf.grep_cword, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>ph", fzf.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>pk", fzf.keymaps, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>xx", fzf.diagnostics_document, { desc = "Document diagnostics" })

--- formatting (conform) ---
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer or selection" })
