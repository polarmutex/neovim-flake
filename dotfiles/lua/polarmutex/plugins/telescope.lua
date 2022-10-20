local map = vim.keymap.set

local M = {}

function M.setup()
    -- keymaps
    map("n", "<leader><leader>", require("telescope.builtin").find_files, { desc = "Telescope: find_files" })
    --bb = cmd "Telescope buffers" "Get buffer list";
    --fb = cmd "Telescope file_browser" "Get buffer list";
    --gf = cmd "lua require('telescope.builtins').live_grep {default_text='function'}" "grep for functions only";
    --gg = cmd "Telescope live_grep" "Fzf fuzzy search";
    --l = cmd "Telescope resume" "last telescope query";

    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<TAB>"] = require("telescope.actions").move_selection_next,
                    ["<S-TAB>"] = require("telescope.actions").move_selection_previous,
                },
            },

            --TODO
            --vimgrep_arguments = {
            --  "${pkgs.ripgrep}/bin/rg",
            --  "--color=never",
            --  "--no-heading",
            --  "--with-filename",
            --  "--line-number",
            --  "--column",
            --  "--smart-case"
            --};
            prompt_prefix = "   ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            --file_sorter = require ("telescope.sorters").get_fuzzy_file;
            file_ignore_patterns = { "node_modules" },
            --generic_sorter = require ("telescope.sorters").get_generic_fuzzy_sorter;
            path_display = { "truncate" },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            use_less = true,
            set_env = { COLORTERM = "truecolor" },
            --file_previewer = require("telescope.previewers").vim_buffer_cat.new;
            --grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new;
            --qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new;
            --buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker;
        },
    })

    _ = require("telescope").load_extension("beancount")
end

return M
