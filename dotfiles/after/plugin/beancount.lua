---@brief [[
--- keymaps:
---
---
---@brief ]]
---@tag polarmutex.beancount
---@config { ["name"] = "Beancount" }

local map = vim.keymap.set

map("n", "<Leader>mc", "<cmd>%s/txn/*/gc<CR>", {
    desc = "beancount-nvim: mark transactions as reconciled",
    noremap = true,
    silent = true,
})

map("n", "<Leader>mt", require("telescope").extensions.beancount.copy_transactions, {
    desc = "Telescope: beancount: copy beancount transactions",
    noremap = true,
    silent = true,
})
