local map = vim.keymap.set

map("n", "<Leader>mc", ":%s/txn/*/gc<CR>", {
    desc = "beancount: mark transactions as cleared",
    noremap = true,
    silent = true,
})

map("n", "<Leader><Leader>", function()
    dapui.close()
end, {
    desc = "DAP: cloese UI",
    noremap = true,
    silent = true,
})
