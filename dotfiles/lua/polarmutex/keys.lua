require("which-key").setup({})
require("which-key").register({
    --K = cmdLua "show_documentation()" "Get Type Information";

    g = {
        name = "Gitsigns",

        b = { "<cmd>Gitsigns blame_line", "Blame line" },
        c = { "<cmd>Gitsigns next_hunk", "Next hunk" },
        n = { "<cmd>Gitsigns next_hunk", "Next hunk" },
        p = { "<cmd>Gitsigns prev_hunk", "Prev hunk" },
        s = { "<cmd>Gitsigns preview_hunk", "Preview hunk" },
    },

    ["<leader>"] = {
        name = "+leader_bindings",

        D = { "<cmd>lua vim.lsp.buf.declaration()", "Jump to Declaration" },
        d = { "<cmd>lua vim.lsp.buf.definition()", "Jump to Definition" },
        i = { "<cmd>lua vim.lsp.buf.implementation()", "Jump to Implementation" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()", "Get function signature" },

        k = { "<cmd>lua vim.lsp.buf.type_definition()", "Get type definition" },
        rn = { "<cmd>lua vim.lsp.buf.rename()", "Rename function/variable" },
        ca = { "<cmd>lua vim.lsp.buf.code_action()", "Perform code action" },
        r = { "<cmd>lua vim.lsp.buf.references()", "Get function/variable refs" },
        e = { "<cmd>lua vim.diagnostic.open_float()", "Get lsp errors" },
        dn = { "<cmd>lua vim.diagnostic.goto_next()", "next diag" },
        dp = { "<cmd>lua vim.diagnostic.goto_prev()", "prev diag" },
        f = { "<cmd>lua vim.lsp.buf.formatting()", "Format buffer" },

        ["<leader>"] = { "<cmd>Telescope find_files<cr>", "search files" },
        --bb = cmd "Telescope buffers" "Get buffer list";
        --fb = cmd "Telescope file_browser" "Get buffer list";
        --gf = cmd "lua require('telescope.builtins').live_grep {default_text='function'}" "grep for functions only";
        --gg = cmd "Telescope live_grep" "Fzf fuzzy search";
        --l = cmd "Telescope resume" "last telescope query";

        --bD = cmd "Bclose!" "Delete buffer aggressively";
        --bN = cmd "tabedit" "New buffer/tab";
        --bd = cmd "q" "Delete buffer";
        --bn = cmd "bnext" "Next buffer";
        --bp = cmd "bprev" "Previous buffer";
        --gb = cmd "BlamerToggle" "Toggle git blame";
        --gc = cmd "Neogen" "generate comments boilerplate";
        --gs = cmd "lua require('neogit').open()" "Open neogit (magit clone)";
        --wd = cmd "q" "Delete window";
        --wh = cmd "wincmd h" "Move window left";
        --wj = cmd "wincmd j" "Move window down";
        --wk = cmd "wincmd k" "Move window up";
        --wl = cmd "wincmd l" "Move window right";
        --ws = cmd "sp" "Split window horizontally";
        --wv = cmd "vs" "Split window vertically";

        --c = {
        --  name = "Crates";
        --  U = cmdLua "require('crates').upgrade_crate()" "upgrade a crate";
        --  Ua = cmdLua "require('crates').upgrade_all_crates()" "upgrade all crates";
        --  u = cmdLua "require('crates').update_crate()" "update a crate";
        --  ua = cmdLua "require('crates').update_all_crates()" "update all crates";
        --};
        --
        --rJ = cmdLua "require'rust-tools.join_lines'.join_lines()" "Join lines rust";
        --rh = cmdLua "require('rust-tools.inlay_hints').toggle_inlay_hints()" "Toggle inlay type hints";
        --rm = cmdLua "require'rust-tools.expand_macro'.expand_macro()" "Expand macro";
        --rpm = cmdLua "require'rust-tools.parent_module'.parent_module()" "Go to parent module";

        -- trouble keybinds
        --"xx" = [ "<cmd>TroubleToggle<CR>" "Toggle trouble diagnostics" ];
        --"xw" = [ "<cmd>TroubleToggle workspace_diagnostics<CR>" "Toggle trouble workspace diagnostics" ];
        --"xd" = [ "<cmd>TroubleToggle document_diagnostics<CR>" "Toggle trouble document diagnostics" ];
        --"xq" = [ "<cmd>TroubleToggle quickfix<CR>" "Toggle trouble quickfix list" ];
        --"xl" = [ "<cmd>TroubleToggle loclist<CR>" "Toggle trouble local list" ];
        --"xr" = [ "<cmd>TroubleToggle lsp_references<CR>" "Toggle trouble lsp references" ];
        --"xn" = [ "cmd lua require(\"trouble\").next({skip_groups = true, jump = true})<CR>" "Jump next diagnostic" ];
        --"xp" = [ "cmd lua require(\"trouble\").previous({skip_groups = true, jump = true})<CR>" "Jump next diagnostic" ];
    },
})
