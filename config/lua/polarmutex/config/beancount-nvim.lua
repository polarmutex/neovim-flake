local M = {}

M.setup = function()
    require("telescope").load_extension("beancount")

    local map = vim.keymap.set
    map("n", "<Leader>mc", "<cmd>%s/txn/*/gc<CR>", {
        desc = "beancount-nvim: mark transactions as reconciled",
        noremap = true,
        silent = true,
    })
    map("n", "<Leader>mt", function()
        require("telescope").extensions.beancount.copy_transactions(require("telescope.themes").get_ivy({}))
    end, {
        desc = "Telescope: beancount: copy beancount transactions",
        noremap = true,
        silent = true,
    })
end

return M
