local M = {}

M.setup = function(jdtls_cmd, java_dbg_path)
    -- The lspconfig configuration for jdtls contains two useful items:
    -- 1. The list of filetypes on which to match.
    -- 2. Custom method for finding the root for a java project.
    local lsp_config = require("lspconfig.server_configurations.jdtls").default_config
    local find_java_project_root = lsp_config.root_dir
    local filetypes = lsp_config.filetypes
    local bundles = {
        java_dbg_path,
    }
    -- Attach jdtls for the proper filetypes (i.e. java).
    -- Existing server will be reused if the root_dir matches.
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MyJdtls", { clear = true }),
        pattern = filetypes,
        callback = function()
            local fname = vim.api.nvim_buf_get_name(0)
            local root_dir = find_java_project_root(fname)
            local project_name = root_dir and vim.fs.basename(root_dir)
            local cmd = { jdtls_cmd }
            if project_name then
                local jdtls_cache_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name
                vim.list_extend(cmd, {
                    "-configuration",
                    jdtls_cache_dir .. "/config",
                    "-data",
                    jdtls_cache_dir .. "/workspace",
                })
            end
            local jdtls_base_config = {
                on_attach = require("polarmutex.utils").on_attach(function(_client, _buffer)
                    --if mason_registry.has_package("java-test") then
                    --    -- custom keymaps for Java test runner (not yet compatible with neotest)
                    --    vim.keymap.set("n", "<leader>tT", function()
                    --        require("jdtls").pick_test({ bufnr = buffer })
                    --    end, { buffer = buffer, desc = "Run specific Test" })
                    --    vim.keymap.set("n", "<leader>tt", function()
                    --        require("jdtls").test_class({ bufnr = buffer })
                    --    end, { buffer = buffer, desc = "Run File" })
                    --    vim.keymap.set("n", "<leader>tr", function()
                    --        require("jdtls").test_nearest_method({ bufnr = buffer })
                    --    end, { buffer = buffer, desc = "Run nearest" })
                    --end
                    -- custom init for Java debugger
                    require("jdtls").setup_dap({ hotcodereplace = "auto" })
                    require("jdtls.dap").setup_dap_main_class_configs()
                    require("jdtls.setup").add_commands()
                end),
                cmd = cmd,
                root_dir = root_dir,
                init_options = {
                    bundles = bundles,
                },
            }
            local jdtls_opts = require("polarmutex.utils").opts("nvim-jdtls")
            require("jdtls").start_or_attach(vim.tbl_deep_extend("force", jdtls_opts or {}, jdtls_base_config))
            require("which-key").register({ c = { x = { name = "Extract" } } }, { prefix = "<leader>" })
        end,
    })
    return true -- avoid duplicate servers
end

return M
