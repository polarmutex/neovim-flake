local M = {}

M.config = function()
    require("kanagawa").setup({
        commentStyle = { italic = true },
        theme = "wave",
    })
    vim.cmd([[colorscheme kanagawa]])
end

return M
