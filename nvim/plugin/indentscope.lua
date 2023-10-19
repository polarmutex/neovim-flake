vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help",
        "lazy",
        "Trouble",
    },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})
require("mini.indentscope").setup({
    symbol = "│",
    options = { try_as_border = true },
})
