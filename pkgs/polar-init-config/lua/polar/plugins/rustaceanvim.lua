---@return rustaceanvim.Opts
vim.g.rustaceanvim = function()
    ---@type rustaceanvim.Opts
    local rustacean_opts = {
        tools = {
            executor = "toggleterm",
        },
        server = {
            default_settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true,
                        loadOutDirsFromCheck = true,
                        runBuildScripts = true,
                    },
                    procMacro = {
                        enable = true,
                        ignored = {
                            ["async-trait"] = { "async_trait" },
                            ["napi-derive"] = { "napi" },
                            ["async-recursion"] = { "async_recursion" },
                        },
                    },
                    inlayHints = {
                        lifetimeElisionHints = {
                            enable = true,
                            useParameterNames = true,
                        },
                    },
                },
            },
        },
    }
    return rustacean_opts
end

return {}
