return {
    {
        "snacks-nvim",
        event = "DeferredUIEnter",
        after = function()
            ---@type snacks.Config
            local opts = {
                statuscolumn = { enabled = true },
            }
            require("snacks").setup(opts)
        end,
    },
}
