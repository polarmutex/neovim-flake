local M = {}

function M.setup()
    -- Load the colorscheme
    local default_colors = require("kanagawa.colors").setup()
    local my_colors = {}
    local overrides = {
        diffAdded = { fg = default_colors.springGreen },
    }
    require("kanagawa").setup({
        globalStatus = true, -- adjust window separators highlight for laststatus=3
        overrides = overrides,
        colors = my_colors,
    })
    --vim.cmd([[colorscheme kanagawa]])
end

return M
