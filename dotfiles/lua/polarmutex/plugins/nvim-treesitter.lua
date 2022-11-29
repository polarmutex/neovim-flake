local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = true,
        },
    })
    local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
    ft_to_parser.xml = "html"
end

return M
