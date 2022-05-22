local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_layout = require("telescope.actions.layout")

require("telescope").setup({
    defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        multi_icon = "<>",

        winblend = 0,

        layout_strategy = "horizontal",
        layout_config = {
            width = 0.95,
            height = 0.85,
            -- preview_cutoff = 120,
            prompt_position = "top",

            horizontal = {
                preview_width = function(_, cols, _)
                    if cols > 200 then
                        return math.floor(cols * 0.4)
                    else
                        return math.floor(cols * 0.6)
                    end
                end,
            },

            vertical = {
                width = 0.9,
                height = 0.95,
                preview_height = 0.5,
            },

            flex = {
                horizontal = {
                    preview_width = 0.9,
                },
            },
        },

        selection_strategy = "reset",
        sorting_strategy = "descending",
        scroll_strategy = "cycle",
        color_devicons = true,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-n>"] = "move_selection_next",

                ["<C-e>"] = actions.results_scrolling_down,
                ["<C-y>"] = actions.results_scrolling_up,

                -- These are new :)
                --["<M-p>"] = action_layout.toggle_preview,
                --["<M-m>"] = action_layout.toggle_mirror,
                -- ["<M-p>"] = action_layout.toggle_prompt_position,

                -- ["<M-m>"] = actions.master_stack,

                -- This is nicer when used with smart-history plugin.
                --["<C-k>"] = actions.cycle_history_next,
                --["<C-j>"] = actions.cycle_history_prev,
                --["<c-g>s"] = actions.select_all,
                --["<c-g>a"] = actions.add_selection,

                --["<c-space>"] = function(prompt_bufnr)
                --    local opts = {
                --        callback = actions.toggle_selection,
                --        loop_callback = actions.send_selected_to_qflist,
                --    }
                --    require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
                --end,

                --["<C-w>"] = function()
                --    vim.api.nvim_input "<c-s-w>"
                --end,
            },

            n = {
                ["<C-e>"] = actions.results_scrolling_down,
                ["<C-y>"] = actions.results_scrolling_up,
            },
        },

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

        history = {
            path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
            limit = 100,
        },
    },

    pickers = {},

    extensions = {
        --TODO fzy_native = {
        --    override_generic_sorter = true,
        --    override_file_sorter = true,
        --},

        --TODO fzf_writer = {
        --    use_highlighter = false,
        --    minimum_grep_characters = 6,
        --},

        --TODO hop = {
        --    -- keys define your hop keys in order; defaults to roughly lower- and uppercased home row
        --    keys = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";" }, -- ... and more

        --    -- Highlight groups to link to signs and lines; the below configuration refers to demo
        --    -- sign_hl typically only defines foreground to possibly be combined with line_hl
        --    sign_hl = { "WarningMsg", "Title" },

        --    -- optional, typically a table of two highlight groups that are alternated between
        --    line_hl = { "CursorLine", "Normal" },

        --    -- options specific to `hop_loop`
        --    -- true temporarily disables Telescope selection highlighting
        --    clear_selection_hl = false,
        --    -- highlight hopped to entry with telescope selection highlight
        --    -- note: mutually exclusive with `clear_selection_hl`
        --    trace_entry = true,
        --    -- jump to entry where hoop loop was started from
        --    reset_selection = true,
        --},

        ["ui-select"] = {
            require("telescope.themes").get_dropdown({
                -- even more opts
            }),
        },

        -- frecency = {
        --   workspaces = {
        --     ["conf"] = "/home/tj/.config/nvim/",
        --     ["nvim"] = "/home/tj/build/neovim",
        --   },
        -- },
    },
})

_ = require("telescope").load_extension("beancount")

local map = vim.keymap.set

local function no_preview(opts)
    return vim.tbl_extend(
        "force",
        require("telescope.themes").get_dropdown({
            layout_config = {
                width = 0.6,
            },
            previewer = false,
        }),
        opts or {}
    )
end

local function builtins()
    require("telescope.builtin").builtin(no_preview())
end

local function grep_prompt()
    require("telescope.builtin").grep_string({
        path_display = { "shorten" },
        search = vim.fn.input("Grep String > "),
        only_sort_text = true,
        use_regex = true,
    })
end

map("n", "<C-p>", require("telescope.builtin").find_files, {
    desc = "Telescope: find files",
    noremap = true,
    silent = true,
})

map("n", "<C-f>", grep_prompt, {
    desc = "Telescope: grep files",
    noremap = true,
    silent = true,
})

map("n", "<Leader>ft", builtins, {
    desc = "Telescope: builtins",
    noremap = true,
    silent = true,
})

map("n", "<Leader>fb", require("telescope.builtin").current_buffer_fuzzy_find, {
    desc = "Telescope: current buffer content",
    noremap = true,
    silent = true,
})

map("n", "<Leader>kb", require("telescope.builtin").keymaps, {
    desc = "Telescope: keymaps",
    noremap = true,
    silent = true,
})

map("n", "<Leader>mt", require("telescope").extensions.beancount.copy_transactions, {
    desc = "Telescope: copy beancount transactions",
    noremap = true,
    silent = true,
})
