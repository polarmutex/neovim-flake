require("hardtime").setup({
    enabled = false,
    disabled_filetypes = {},
})
require("precognition").setup({ startVisible = false })

vim.keymap.set("n", "<leader>hh", function()
    require("precognition").toggle()
    require("hardtime").toggle()
end, { desc = "[S]earch [H]elp" })

return {}
