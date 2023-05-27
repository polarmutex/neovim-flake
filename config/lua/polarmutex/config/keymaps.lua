local M = {}

---@mod polarmutex.keymaps Keymaps

M.setup = function()
    local map = vim.keymap.set

    -- visual select move and rehighlight
    map("v", "J", ":m '>+1<CR>gv=gv")
    map("v", "K", ":m '<-2<CR>gv=gv")

    -- center screen on search and page movements
    map("n", "<C-d>", "<C-d>zz")
    map("n", "<C-u>", "<C-u>zz")
    map("n", "n", "nzzzv")
    map("n", "N", "Nzzzv")

    -- greatest remap ever
    map("x", "<leader>p", [["_dP]])

    -- next greatest remap ever : asbjornHaland
    map({ "n", "v" }, "<leader>y", [["+y]])
    map("n", "<leader>Y", [["+Y]])

    map({ "n", "v" }, "<leader>d", [["_d]])

    map("n", "<C-k>", "<cmd>cnext<CR>zz")
    map("n", "<C-j>", "<cmd>cprev<CR>zz")
    map("n", "<leader>k", "<cmd>lnext<CR>zz")
    map("n", "<leader>j", "<cmd>lprev<CR>zz")

    ---@class Git
    ---@brief [[
    ---<leader>gs - neogit - git status
    ---<leader>gc - neogit - git commit
    ---@brief ]]
    map("n", "<leader>gs", function()
        require("neogit").open()
    end)
    map("n", "<leader>gc", function()
        require("neogit").open({ "commit" })
    end)
end

return M
