return {
    {
        "snacks-nvim",
        event = "DeferredUIEnter",
        after = function()
            ---@type snacks.Config
            local opts = {
                bigfile = {},
                indent = {},
                picker = {
                    -- actions = require("trouble.sources.snacks").actions,
                    -- win = {
                    --     input = {
                    --         keys = {
                    --             ["<c-t>"] = {
                    --                 "trouble_open",
                    --                 mode = { "n", "i" },
                    --             },
                    --         },
                    --     },
                    -- },
                },
                scroll = {},
                statuscolumn = { enabled = true },
                ---@type snacks.picker.Config
            }
            local snacks = require("snacks")
            snacks.setup(opts)

            vim.keymap.set("n", "<leader>,", function()
                snacks.picker.buffers()
            end, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>/", function()
                snacks.picker.grep()
            end, { desc = "Grep" })
            vim.keymap.set("n", "<leader>:", function()
                snacks.picker.command_history()
            end, { desc = "Command History" })
            vim.keymap.set("n", "<leader><space>", function()
                snacks.picker.files()
            end, { desc = "Find Files" })
            -- find
            vim.keymap.set("n", "<leader>fb", function()
                snacks.picker.buffers()
            end, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fc", function()
                snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Find Config File" })
            vim.keymap.set("n", "<leader>ff", function()
                snacks.picker.files()
            end, { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", function()
                snacks.picker.git_files()
            end, { desc = "Find Git Files" })
            vim.keymap.set("n", "<leader>fr", function()
                snacks.picker.recent()
            end, { desc = "Recent" })
            -- git
            vim.keymap.set("n", "<leader>gc", function()
                snacks.picker.git_log()
            end, { desc = "Git Log" })
            vim.keymap.set("n", "<leader>gs", function()
                snacks.picker.git_status()
            end, { desc = "Git Status" })
            -- Grep
            vim.keymap.set("n", "<leader>sb", function()
                snacks.picker.lines()
            end, { desc = "Buffer Lines" })
            vim.keymap.set("n", "<leader>sB", function()
                snacks.picker.grep_buffers()
            end, { desc = "Grep Open Buffers" })
            vim.keymap.set("n", "<leader>sg", function()
                snacks.picker.grep()
            end, { desc = "Grep" })
            -- vim.keymap.set("n", "<leader>sw", function()
            --     snacks.picker.grep_word()
            -- end, { desc = "Visual selection or word", mode = { "n", "x" } })
            -- search
            vim.keymap.set("n", '<leader>s"', function()
                snacks.picker.registers()
            end, { desc = "Registers" })
            vim.keymap.set("n", "<leader>sa", function()
                snacks.picker.autocmds()
            end, { desc = "Autocmds" })
            vim.keymap.set("n", "<leader>sc", function()
                snacks.picker.command_history()
            end, { desc = "Command History" })
            vim.keymap.set("n", "<leader>sC", function()
                snacks.picker.commands()
            end, { desc = "Commands" })
            vim.keymap.set("n", "<leader>sd", function()
                snacks.picker.diagnostics()
            end, { desc = "Diagnostics" })
            vim.keymap.set("n", "<leader>sh", function()
                snacks.picker.help()
            end, { desc = "Help Pages" })
            vim.keymap.set("n", "<leader>sH", function()
                snacks.picker.highlights()
            end, { desc = "Highlights" })
            vim.keymap.set("n", "<leader>sj", function()
                snacks.picker.jumps()
            end, { desc = "Jumps" })
            vim.keymap.set("n", "<leader>sk", function()
                snacks.picker.keymaps()
            end, { desc = "Keymaps" })
            vim.keymap.set("n", "<leader>sl", function()
                snacks.picker.loclist()
            end, { desc = "Location List" })
            vim.keymap.set("n", "<leader>sM", function()
                snacks.picker.man()
            end, { desc = "Man Pages" })
            vim.keymap.set("n", "<leader>sm", function()
                snacks.picker.marks()
            end, { desc = "Marks" })
            vim.keymap.set("n", "<leader>sR", function()
                snacks.picker.resume()
            end, { desc = "Resume" })
            vim.keymap.set("n", "<leader>sq", function()
                snacks.picker.qflist()
            end, { desc = "Quickfix List" })
            vim.keymap.set("n", "<leader>uC", function()
                snacks.picker.colorschemes()
            end, { desc = "Colorschemes" })
            vim.keymap.set("n", "<leader>qp", function()
                snacks.picker.projects()
            end, { desc = "Projects" })
            -- LSP
            vim.keymap.set("n", "gd", function()
                snacks.picker.lsp_definitions()
            end, { desc = "Goto Definition" })
            vim.keymap.set("n", "gr", function()
                snacks.picker.lsp_references()
            end, { nowait = true, desc = "References" })
            vim.keymap.set("n", "gI", function()
                snacks.picker.lsp_implementations()
            end, { desc = "Goto Implementation" })
            vim.keymap.set("n", "gy", function()
                snacks.picker.lsp_type_definitions()
            end, { desc = "Goto T[y]pe Definition" })
            vim.keymap.set("n", "<leader>ss", function()
                snacks.picker.lsp_symbols()
            end, { desc = "LSP Symbols" })
        end,
    },
}
