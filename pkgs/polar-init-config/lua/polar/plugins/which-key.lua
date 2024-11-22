return {
    {
        "which-key-nvim",
        event = "DeferredUIEnter",
        after = function()
            require("which-key").setup({
                icons = {
                    mappings = false,
                },
            })
        end,
    },
}
