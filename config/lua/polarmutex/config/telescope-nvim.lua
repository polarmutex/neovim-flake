local M = {}

M.config = function()
    local map = vim.keymap.set
    -- keymaps
    map("n", "<leader><leader>", require("telescope.builtin").find_files, { desc = "Telescope: find_files" })

    require("telescope").setup({
        pickers = {
            find_files = {
                theme = "dropdown",
            },
            live_grep = {},
            buffers = {
                theme = "ivy",
            },
            help_tags = {
                theme = "ivy",
            },
            keymaps = {
                theme = "ivy",
            },
            lsp_references = {
                theme = "ivy",
            },
            git_commits = {
                theme = "ivy",
            },
            git_bcommits = {
                theme = "ivy",
            },
            git_branches = {
                theme = "ivy",
            },
        },
    })
end

return M
