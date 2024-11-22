require("neogit").setup({
    kind = "split",
    disable_builtin_notifications = true,
    disable_commit_confirmation = true,
    signs = {
        section = { "", "" },
        item = { "", "" },
    },

    integrations = {
        diffview = true,
    },
})

return {
    -- {
    --     "neogit",
    --     cmd = "Neogit",
    --     dependencies = {
    --         "plenary-nvim", -- required
    --         "telescope-nvim", -- optional
    --         "diffview-nvim", -- optional
    --     },
    --     after = function()
    --     end,
    -- },
}
