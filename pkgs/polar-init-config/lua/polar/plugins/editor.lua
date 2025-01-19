return {
    {
        "flash-nvim",
        event = "DeferredUIEnter",
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
        after = function()
            ---@type Flash.Config
            local opts = {}
            require("flash").setup(opts)
        end,
    },
    -- which-key helps you remember key bindings by showing a popup
    -- with the active keybindings of the command you started typing.
    {
        "which-key-nvim",
        event = "DeferredUIEnter",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<c-w><space>",
                function()
                    require("which-key").show({ keys = "<c-w>", loop = true })
                end,
                desc = "Window Hydra Mode (which-key)",
            },
        },
        after = function()
            local opts = {
                preset = "helix",
                defaults = {},
                spec = {
                    {
                        mode = { "n", "v" },
                        { "<leader><tab>", group = "tabs" },
                        { "<leader>c", group = "code" },
                        { "<leader>d", group = "debug" },
                        { "<leader>dp", group = "profiler" },
                        { "<leader>f", group = "file/find" },
                        { "<leader>g", group = "git" },
                        { "<leader>gh", group = "hunks" },
                        { "<leader>q", group = "quit/session" },
                        { "<leader>s", group = "search" },
                        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                        { "[", group = "prev" },
                        { "]", group = "next" },
                        { "g", group = "goto" },
                        { "gs", group = "surround" },
                        { "z", group = "fold" },
                        {
                            "<leader>b",
                            group = "buffer",
                            expand = function()
                                return require("which-key.extras").expand.buf()
                            end,
                        },
                        {
                            "<leader>w",
                            group = "windows",
                            proxy = "<c-w>",
                            expand = function()
                                return require("which-key.extras").expand.win()
                            end,
                        },
                        -- better descriptions
                        { "gx", desc = "Open with system app" },
                    },
                },
            }
            require("which-key").setup(opts)
        end,
    },
    -- git signs highlights text that has changed since the list
    -- git commit, and also lets you interactively stage & unstage
    -- hunks in a commit.
    {
        "gitsigns-nvim",
        event = "DeferredUIEnter",
        after = function()
            local gitsigns = require("gitsigns")
            local opts = {
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                    untracked = { text = "▎" },
                },
                signs_staged = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                },
                on_attach = function(buffer)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                    end

                    map("n", "]h", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end, "Next Hunk")
                    map("n", "[h", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end, "Prev Hunk")
                    map("n", "]H", function()
                        gs.nav_hunk("last")
                    end, "Last Hunk")
                    map("n", "[H", function()
                        gs.nav_hunk("first")
                    end, "First Hunk")
                    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                    map("n", "<leader>ghb", function()
                        gs.blame_line({ full = true })
                    end, "Blame Line")
                    map("n", "<leader>ghB", function()
                        gs.blame()
                    end, "Blame Buffer")
                    map("n", "<leader>ghd", gs.diffthis, "Diff This")
                    map("n", "<leader>ghD", function()
                        gs.diffthis("~")
                    end, "Diff This ~")
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
                end,
            }
            gitsigns.setup(opts)
        end,
    },
    -- better diagnostics list and others
    {
        "trouble-nvim",
        cmd = { "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
            { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
        after = function()
            local opts = {
                modes = {
                    lsp = {
                        win = { position = "right" },
                    },
                },
            }
            require("trouble").setup(opts)
        end,
    },
    {
        "todo-comments-nvim",
        keys = {
            {
                "<leader>st",
                function()
                    Snacks.picker.todo_comments()
                end,
                desc = "Todo",
            },
            {
                "<leader>sT",
                function()
                    Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
                end,
                desc = "Todo/Fix/Fixme",
            },
        },
        after = function()
            local todo = require("todo-comments")
            local opts = {}
            todo.setup(opts)
        end,
    },
}
