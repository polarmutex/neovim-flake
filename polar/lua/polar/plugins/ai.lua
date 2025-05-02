return {
    {
        "codecompanion-nvim",
        event = "DeferredUIEnter",
        keys = {},
        after = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "ollama",
                    },
                    inline = {
                        adapter = "ollama",
                    },
                },
            })
        end,
    },
}
