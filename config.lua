-- markdown-specific settings.
-- Configure tabstop and stuff
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "set tabstop=4 | set shiftwidth=4 | set expandtab | set autoindent",
})

-- Map <leader>b to make the selection bold
-- Needs vim-surround
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "vmap <leader>b S*<cr>gvS*",
})
-- Map ]\ to create a quick link
-- Needs vim-surround
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    command = "vmap ]\\ S]%a()<esc>",
})
-- Generic prose config
prose_file_formats = { "markdown" }
for _, file_format in ipairs(prose_file_formats) do
    -- Add endash shortcut
    vim.api.nvim_create_autocmd("FileType", {
        pattern = file_format,
        command = "imap -- – | imap --<Space> –<Space>",
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = file_format,
        command = "setlocal spell! spelllang=en_us",
    })
end

-- Json pretty print
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    command = "nnoremap <leader>pp :%!jq '.'<CR>",
})

-- Pass custom files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "/dev/shm/pass.?*/?*.txt", "$TMPDIR/pass.?*/?*.txt", "/tmp/pass.?*/?*.txt" },
    command = "nnoremap <leader>u oUsername: | nnoremap <leader>e oEmail: ",
})

-- Better whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = ":StripWhitespace",
})

local cmp = require("cmp")

cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path", option = { trailing_slash = true } },
    }, {
        { name = "cmdline" },
    }),
})

require("nvim-autopairs").setup({})
-- Nix custom settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    command = "set tabstop=2 | set shiftwidth=2 | set expandtab | set autoindent",
})

-- Custom shortcuts
-- Clear the screeen from garbage
vim.api.nvim_set_keymap(
    "n",
    "<leader>l",
    ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>",
    { noremap = true, silent = true }
)

-- Load custom tree-sitter grammar for org filetype

-- Tree-sitter configuration

require("orgmode").setup_ts_grammar()

-- Tree-sitter configuration
require("nvim-treesitter.configs").setup({
    -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
    highlight = {
        enable = true,
        disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
        additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
    },
    ensure_installed = { "org" }, -- Or run :TSUpdate org
})

require("orgmode").setup({
    org_agenda_files = { "~/orgmode/*" },
    org_default_notes_file = "~/orgmode/refile.org",
})

-- Automatically format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = vim.lsp.buf.formatting_sync,
})

-- Adds ability to do cs"m to replace single line string with multiline.
vim.api.nvim_exec(
    [[
let g:surround_{char2nr('m')} = "''\n\n''"
]],
    false
)
