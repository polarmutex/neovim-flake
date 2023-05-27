---@mod polarmutex.plugins.beancount Beancount
---@brief [[
--- keymaps:
---
---
---@brief ]]
---@tag polarmutex.beancount

local beancount_nvim_spec = {
    name = "beancount.nvim",
    dir = "@neovimPlugin.beancount-nvim@",
    ft = "beancount",
}

beancount_nvim_spec.config = function()
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
    --require("beancount").setup({})
end

return {
    beancount_nvim_spec,
}
