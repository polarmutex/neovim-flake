require("gitsigns").setup {
    signs = {
        add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr" },
        change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr" },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
        topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- stylua: ignore start
        map("n", "<leader>hn", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
        map("n", "<leader>hp", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
        map("n", "<leader>hs", gs.stage_hunk)
        map("n", "<leader>hu", gs.undo_stage_hunk)
        map({ "n", "v" }, "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>")
        map("n", "<leader>hb", gs.blame_line)
        map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hP", gs.preview_hunk)
        -- stylua: ignore end
    end,
    --preview_config = {
    --    border = Util.borders,
    --},
    current_line_blame = false,
    sign_priority = 5,
    update_debounce = 500,
    status_formatter = nil, -- Use default
    diff_opts = {
        internal = true,
    },
}
