local utils = require("polar.utils.keymap")

local function toggle_spell_check()
    vim.opt.spell = not (vim.opt.spell:get())
end

-- clear search
utils.map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
utils.map("n", "[d", vim.diagnostic.get_prev, { desc = "Go to previous [D]iagnostic message" })
utils.map("n", "]d", vim.diagnostic.get_next, { desc = "Go to next [D]iagnostic message" })
utils.map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
utils.map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
utils.map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
utils.map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
utils.map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
utils.map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
utils.map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- TODO

-- visual select move and rehighlight
utils.map("v", "J", ":m '>+1<CR>gv=gv")
utils.map("v", "K", ":m '<-2<CR>gv=gv")

-- center screen on search and page movements
utils.map("n", "<C-d>", "<C-d>zz")
utils.map("n", "<C-u>", "<C-u>zz")
utils.map("n", "n", "nzzzv")
utils.map("n", "N", "Nzzzv")

-- greatest remap ever
utils.map("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
utils.map({ "n", "v" }, "<leader>y", [["+y]])
utils.map("n", "<leader>Y", [["+Y]])

utils.map({ "n", "v" }, "<leader>d", [["_d]])

utils.map("n", "<C-k>", "<cmd>cnext<CR>zz")
utils.map("n", "<C-j>", "<cmd>cprev<CR>zz")
utils.map("n", "<leader>k", "<cmd>lnext<CR>zz")
utils.map("n", "<leader>j", "<cmd>lprev<CR>zz")

utils.map("n", "<leader>S", toggle_spell_check, { noremap = true, silent = true })

---@class Git
---@brief [[
---<leader>gs - neogit - git status
---<leader>gc - neogit - git commit
---@brief ]]
utils.map("n", "<leader>gs", function()
    require("neogit").open()
end)
utils.map("n", "<leader>gc", function()
    require("neogit").open({ "commit" })
end)

-- old look into
-- Clear highlight
--nmap."<leader>/" = ":nohl<cr>";

-- Ctrl + hjkl - in insert to move between characters
--inoremap."<C-h>" = "<Left>";
--inoremap."<C-j>" = "<Down>";
--inoremap."<C-k>" = "<Up>";
--inoremap."<C-l>" = "<Right>";

-- Ctrl + hjkl - in normal mode to move betwen splits,
--nmap."<C-h>" = "<C-w>h";
--nmap."<C-j>" = "<C-w>j";
--nmap."<C-k>" = "<C-w>k";
--nmap."<C-l>" = "<C-w>l";

-- q to quit, Q to record macro
--nnoremap.Q = "q";
--nnoremap.q = ":q<cr>";

-- q to quit, Q to record macro
--vnoremap."<" = "<gv";
--vnoremap.">" = ">gv";

-- Make Y consistent with commands like D,C
--nmap.Y = "y$";

--nmap."<C-c>" = ''"+yy'';
--vmap."<C-c>" = ''"+y'';
--imap."<C-v>" = ''<Esc>"+pa'';

-- Ctrl+Backspace to delete previous word. https://vi.stackexchange.com/questions/16139/s-bs-and-c-bs-mappings-not-working
--inoremap."<C-BS>" = "<C-W>";

-- K = cmdLua "show_documentation()" "Get Type Information";

--g = {
--  name = "Gitsigns";

--  b = cmd "Gitsigns blame_line" "Blame line";
--  c = cmd "Gitsigns next_hunk" "Next hunk";
--  n = cmd "Gitsigns next_hunk" "Next hunk";
--  p = cmd "Gitsigns prev_hunk" "Prev hunk";
--  s = cmd "Gitsigns preview_hunk" "Preview hunk";
--};

--"['<leader>']" = {
--  name = "+leader_bindings";

--  D = cmdLua "vim.lsp.buf.declaration()" "Jump to Declaration";
--  d = cmdLua "vim.lsp.buf.definition()" "Jump to Definition";
--  i = cmdLua "vim.lsp.buf.implementation()" "Jump to Implementation";
--  s = cmdLua "vim.lsp.buf.signature_help()" "Get function signature";

--  k = cmdLua "vim.lsp.buf.type_definition()" "Get type definition";
--  rn = cmdLua "vim.lsp.buf.rename()" "Rename function/variable";
--  ca = cmdLua "vim.lsp.buf.code_action()" "Perform code action";
--  r = cmdLua "vim.lsp.buf.references()" "Get function/variable refs";
--  e = cmdLua "vim.diagnostic.open_float()" "Get lsp errors";
--  dn = cmdLua "vim.diagnostic.goto_next()" "next diag";
--  dp = cmdLua "vim.diagnostic.goto_prev()" "prev diag";
--  f = cmdLua "vim.lsp.buf.formatting()" "Format buffer";

--  "['<leader>']" = ["<cmd>Telescope find_files<cr>" "search files"];
--  bb = cmd "Telescope buffers" "Get buffer list";
--  fb = cmd "Telescope file_browser" "Get buffer list";
--  gf = cmd "lua require('telescope.builtins').live_grep {default_text='function'}" "grep for functions only";
--  gg = cmd "Telescope live_grep" "Fzf fuzzy search";
--  l = cmd "Telescope resume" "last telescope query";

--  bD = cmd "Bclose!" "Delete buffer aggressively";
--  bN = cmd "tabedit" "New buffer/tab";
--  bd = cmd "q" "Delete buffer";
--  bn = cmd "bnext" "Next buffer";
--  bp = cmd "bprev" "Previous buffer";
--  gb = cmd "BlamerToggle" "Toggle git blame";
--  gc = cmd "Neogen" "generate comments boilerplate";
--  gs = cmd "lua require('neogit').open()" "Open neogit (magit clone)";
--  wd = cmd "q" "Delete window";
--  wh = cmd "wincmd h" "Move window left";
--  wj = cmd "wincmd j" "Move window down";
--  wk = cmd "wincmd k" "Move window up";
--  wl = cmd "wincmd l" "Move window right";
--  ws = cmd "sp" "Split window horizontally";
--  wv = cmd "vs" "Split window vertically";

--  c = {
--    name = "Crates";
--    U = cmdLua "require('crates').upgrade_crate()" "upgrade a crate";
--    Ua = cmdLua "require('crates').upgrade_all_crates()" "upgrade all crates";
--    u = cmdLua "require('crates').update_crate()" "update a crate";
--    ua = cmdLua "require('crates').update_all_crates()" "update all crates";
--  };

--  rJ = cmdLua "require'rust-tools.join_lines'.join_lines()" "Join lines rust";
--  rh = cmdLua "require('rust-tools.inlay_hints').toggle_inlay_hints()" "Toggle inlay type hints";
--  rm = cmdLua "require'rust-tools.expand_macro'.expand_macro()" "Expand macro";
--  rpm = cmdLua "require'rust-tools.parent_module'.parent_module()" "Go to parent module";

--  # trouble keybinds
--  "xx" = ["<cmd>TroubleToggle<CR>" "Toggle trouble diagnostics"];
--  "xw" = ["<cmd>TroubleToggle workspace_diagnostics<CR>" "Toggle trouble workspace diagnostics"];
--  "xd" = ["<cmd>TroubleToggle document_diagnostics<CR>" "Toggle trouble document diagnostics"];
--  "xq" = ["<cmd>TroubleToggle quickfix<CR>" "Toggle trouble quickfix list"];
--  "xl" = ["<cmd>TroubleToggle loclist<CR>" "Toggle trouble local list"];
--  "xr" = ["<cmd>TroubleToggle lsp_references<CR>" "Toggle trouble lsp references"];
--  "xn" = ["cmd lua require(\"trouble\").next({skip_groups = true, jump = true})<CR>" "Jump next diagnostic"];
--  "xp" = ["cmd lua require(\"trouble\").previous({skip_groups = true, jump = true})<CR>" "Jump next diagnostic"];
