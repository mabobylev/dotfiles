vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

--- tokyonight theme ----
require("tokyonight").setup({})

--- lualine setup ----
require('lualine').setup{
    options = {
        icons_enabled = true,
        theme = "auto",
        -- theme  = "tokyonight",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
}
--- mini traisspace ----
require('mini.trailspace').setup()

--- mini buffers map ----
-- require('mini.map').setup()

--- mini tabline ----
require('mini.tabline').setup()

--- mini hipatterns ----
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

--- mini pairs ----
require('mini.pairs').setup()

--- mini git ----
require('mini.git').setup()

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

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
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
require('mini.starter').setup()

--- mini cmdline completion ---
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})

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

--- mini picker ---
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

--- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>ph", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })

--- mini completions --- 
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
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

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })

--- fzf ---
local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
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
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "FZF - find files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "FZF - find files" })

--- completion plugin ---
-- require('blink.cmp').setup({
--     fuzzy = { implementation = 'prefer_rust_with_warning' },
--     signature = { enabled = true },
--     keymap = {
--         preset = "default",
--         ["<C-space>"] = {},
--         ["<C-p>"] = {},
--         ["<Tab>"] = {},
--         ["<S-Tab>"] = {},
--         ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
--         ["<C-n>"] = { "select_and_accept" },
--         ["<C-k>"] = { "select_prev", "fallback" },
--         ["<C-j>"] = { "select_next", "fallback" },
--         ["<C-b>"] = { "scroll_documentation_down", "fallback" },
--         ["<C-f>"] = { "scroll_documentation_up", "fallback" },
--         ["<C-l>"] = { "snippet_forward", "fallback" },
--         ["<C-h>"] = { "snippet_backward", "fallback" },
--         -- ["<C-e>"] = { "hide" },
--     },
--
--     appearance = {
--         use_nvim_cmp_as_default = true,
--         nerd_font_variant = "normal",
--     },
--
--     completion = {
--         documentation = {
--             auto_show = true,
--             auto_show_delay_ms = 200,
--         }
--     },
--
--     cmdline = {
--         keymap = {
--             preset = 'inherit',
--             ['<CR>'] = { 'accept_and_enter', 'fallback' },
--         },
--     },
--
--     sources = { default = { "lsp" } }
-- })
