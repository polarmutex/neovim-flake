local map = vim.keymap.set

map("n", "<Leader>mc", ":%s/txn/*/gc<CR>", {
    desc = "beancount: mark transactions as cleared",
    noremap = true,
    silent = true,
})
