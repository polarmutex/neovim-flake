local M = {}

M.setup = function()
    -- how to test local plugins
    --vim.o.runtimepath = "~/repos/personal/vim-be-good/intermediate"

    local api = vim.api

    --- Remove all trailing whitespace on save
    --function Trim()
    -- Save cursor position
    --    local _, lnum, col, off, _ = unpack(vim.fn.getcurpos())
    -- Trim trailing whitespace
    --    vim.cmd([[keeppatterns %s#\s\+$##e]])
    -- Trim trailing blank lines
    --vim.cmd [[keeppatterns vg#\_s*\S#d]]
    -- Restore cursor position
    --    vim.fn.cursor(lnum, col, off)
    --end
    local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
    api.nvim_create_autocmd("BufWritePre", {
        command = [[:%s/\s\+$//e]],
        --callback = Trim(),
        group = TrimWhiteSpaceGrp,
    })

    -- don't auto comment new line
    api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.highlight.on_yank()`
    api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
        callback = function()
            vim.highlight.on_yank()
        end,
    })

    -- go to last loc when opening a buffer
    api.nvim_create_autocmd(
        "BufReadPost",
        { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
    )
    -- api.nvim_create_autocmd("BufReadPost", {
    --     desc = "Open file at the last position it was edited earlier",
    --     group = misc_augroup,
    --     pattern = "*",
    --     command = 'silent! normal! g`"zv',
    -- })

    -- show cursor line only in active window
    local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
    api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
        pattern = "*",
        command = "set cursorline",
        group = cursorGrp,
    })
    api.nvim_create_autocmd(
        { "InsertEnter", "WinLeave" },
        { pattern = "*", command = "set nocursorline", group = cursorGrp }
    )

    -- Enable spell checking for certain file types
    api.nvim_create_autocmd(
        { "BufRead", "BufNewFile" },
        { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" }
    )

    -- zellij
    if vim.env.ZELLIJ ~= nil then
        vim.fn.system({ "zellij", "action", "switch-mode", "locked" })
    end
end

return M
