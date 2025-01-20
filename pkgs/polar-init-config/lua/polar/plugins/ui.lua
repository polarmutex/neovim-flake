return {
    {
        "bufferline-nvim",
        event = "DeferredUIEnter",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
            { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
        },
        after = function()
            local opts = {
                options = {
                    close_command = function(n)
                        Snacks.bufdelete(n)
                    end,
                    right_mouse_command = function(n)
                        Snacks.bufdelete(n)
                    end,
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = false,
                    --TODO diagnostics_indicator = function(_, _, diag)
                    --     local icons = LazyVim.config.icons.diagnostics
                    --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                    --         .. (diag.warning and icons.Warn .. diag.warning or "")
                    --     return vim.trim(ret)
                    -- end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                    },
                    ---@param opts bufferline.IconFetcherOpts
                    -- TODO get_element_icon = function(opts)
                    --     return LazyVim.config.icons.ft[opts.filetype]
                    -- end,
                },
            }
            require("bufferline").setup(opts)

            local Offset = require("bufferline.offset")
            if not Offset.edgy then
                local get = Offset.get
                Offset.get = function()
                    if package.loaded.edgy then
                        local old_offset = get()
                        local layout = require("edgy.config").layout
                        local ret = { left = "", left_size = 0, right = "", right_size = 0 }
                        for _, pos in ipairs({ "left", "right" }) do
                            local sb = layout[pos]
                            local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                            if sb and #sb.wins > 0 then
                                ret[pos] = old_offset[pos .. "_size"] > 0 and old_offset[pos]
                                    or pos == "left" and ("%#Bold#" .. title .. "%*" .. "%#BufferLineOffsetSeparator#│%*")
                                    or pos == "right"
                                        and ("%#BufferLineOffsetSeparator#│%*" .. "%#Bold#" .. title .. "%*")
                                ret[pos .. "_size"] = old_offset[pos .. "_size"] > 0 and old_offset[pos .. "_size"]
                                    or sb.bounds.width
                            end
                        end
                        ret.total_size = ret.left_size + ret.right_size
                        if ret.total_size > 0 then
                            return ret
                        end
                    end
                    return get()
                end
                Offset.edgy = true
            end
        end,
    },
    {
        "noice-nvim",
        event = "DeferredUIEnter",
        keys = {
            { "<leader>sn", "", desc = "+noice" },
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "Redirect Cmdline",
            },
            {
                "<leader>snl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            {
                "<leader>snh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            {
                "<leader>sna",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            {
                "<leader>snd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
            {
                "<leader>snt",
                function()
                    require("noice").cmd("pick")
                end,
                desc = "Noice Picker (Telescope/FzfLua)",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Forward",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Backward",
                mode = { "i", "n", "s" },
            },
        },
        after = function()
            local opts = {
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "msg_show",
                            any = {
                                { find = "%d+L, %d+B" },
                                { find = "; after #%d+" },
                                { find = "; before #%d+" },
                            },
                        },
                        view = "mini",
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                },
            }
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end
            require("noice").setup(opts)
        end,
    },
    {
        "nui-nvim",
        lazy = true,
    },
    {
        "edgy-nvim",
        event = "DeferredUIEnter",
        keys = {
            {
                "<leader>ue",
                function()
                    require("edgy").toggle()
                end,
                desc = "Edgy Toggle",
            },
            {
                "<leader>uE",
                function()
                    require("edgy").select()
                end,
                desc = "Edgy Select Window",
            },
        },
        after = function()
            local opts = {
                top = {
                    {
                        ft = "gitcommit",
                        size = { height = 0.5 },
                        wo = { signcolumn = "yes:2" },
                    },
                },
                bottom = {
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(_buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    "Trouble",
                    {
                        ft = "qf",
                        title = "QuickFix",
                    },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                left = {
                    { title = "Neotest Summary", ft = "neotest-summary" },
                },
                right = {
                    {
                        title = "Overseer",
                        ft = "OverseerList",
                        open = function()
                            require("overseer").open()
                        end,
                    },
                },
                keys = {
                    -- increase width
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
                exit_when_last = true,
            }
            -- trouble
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "trouble",
                    filter = function(_buf, win)
                        return vim.w[win].trouble
                            and vim.w[win].trouble.position == pos
                            and vim.w[win].trouble.type == "split"
                            and vim.w[win].trouble.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            -- snacks terminal
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "snacks_terminal",
                    size = { height = 0.4 },
                    title = "%{b:snacks_terminal.id}: %{b:term_title}",
                    filter = function(_buf, win)
                        return vim.w[win].snacks_win
                            and vim.w[win].snacks_win.position == pos
                            and vim.w[win].snacks_win.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            require("edgy").setup(opts)
        end,
    },
}
