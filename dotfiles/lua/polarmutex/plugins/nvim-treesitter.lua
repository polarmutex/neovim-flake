local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = true,
        },
    })
end

return M
