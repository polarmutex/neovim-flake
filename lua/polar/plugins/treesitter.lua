return {
    {
        "nvim-treesitter",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        after = function()
            -- Enable treesitter for all buffers
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })

            -- Configure treesitter
            require("nvim-treesitter.configs").setup({
                ensure_installed = {}, -- We handle this via Nix
                auto_install = false, -- Disable auto-install since we use Nix

                highlight = {
                    enable = true,
                    -- Disable slow treesitter highlight for large files
                    disable = function(_lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                },

                indent = {
                    enable = true,
                    -- Disable indent for certain languages if needed
                    disable = { "python" }, -- Python indentation can be problematic
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            })
        end,
    },
}
