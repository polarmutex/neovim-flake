local M = {}

M.setup = function()
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
end

return M
