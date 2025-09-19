return {
    {
        "codecompanion-nvim",
        event = "DeferredUIEnter",
        keys = {},
        dependencies = { "mcphub.nvim" },
        after = function()
            -- require("codecompanion").setup({
            --     adapters = {
            --         litellm = function()
            --             return require("codecompanion.adapters").extend("openai_compatible", {
            --                 env = {
            --                     url = "https://litellm.brianryall.xyz",
            --                     api_key = "sk-Pww-CDOpPJ03DyTFNaj8UA",
            --                 },
            --                 roles = {
            --                     main = "main",
            --                 },
            --                 schema = {
            --                     model = {
            --                         default = "gemini/gemini-2.5-pro",
            --                     },
            --                 },
            --             })
            --         end,
            --     },
            --     extensions = {
            --         mcphub = {
            --             callback = "mcphub.extensions.codecompanion",
            --             opts = {
            --                 show_result_in_chat = true, -- Show mcp tool results in chat
            --                 make_vars = true, -- Convert resources to #variables
            --                 make_slash_commands = true, -- Add prompts as /slash commands
            --             },
            --         },
            --     },
            --     strategies = {
            --         chat = {
            --             adapter = "litellm",
            --         },
            --         inline = {
            --             adapter = "litellm",
            --         },
            --     },
            -- })
        end,
    },
    {
        "mcphub.nvim",
        dependencies = { "plenary.nvim" },
        after = function()
            require("mcphub").setup({})
        end,
    },
}
