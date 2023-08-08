local M = {}

M.setup = function()
    require("kanagawa").setup({
        commentStyle = { italic = true },
        theme = "wave",
    })
    vim.cmd([[colorscheme kanagawa]])
end

return M
