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
    lazy = true,
    --ft = "beancount",
}

beancount_nvim_spec.config = function()
    --require("gitsigns").setup({})
end

return {
    beancount_nvim_spec,
}
