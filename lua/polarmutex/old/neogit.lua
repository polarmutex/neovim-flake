local M = {}

function M.setup()
    require("neogit").setup({
        kind = "split",
        disable_builtin_notifications = true,
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
