vim.list_extend(require("polar.lazy.specs"), {
    {
        "kanagawa-nvim",
        event = "UIEnter",
        colorscheme = "kanagawa-dragon",
        after = function()
            require("kanagawa").setup({
                transparent = true,
                theme = "dragon",
            })
            vim.cmd([[ colorscheme kanagawa-dragon ]])
        end,
    },
})
