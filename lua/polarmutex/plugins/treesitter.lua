local treesitter_spec = {
    name = "nvim-treesitter",
    dir = "@neovimPlugin.nvim-treesitter@",
    dependencies = {
        --{ "nvim-treesitter/nvim-treesitter-textobjects", {} },
        --{ "nvim-treesitter/nvim-treesitter-refactor", {} },
        --{ "windwp/nvim-ts-autotag", {} },
        --{ "JoosepAlviste/nvim-ts-context-commentstring", {} },
        --{ "nvim-treesitter/playground", {} },
    },
    lazy = false,
}
treesitter_spec.config = function()
    require("nvim-treesitter.configs").setup({
        parser_install_dir = "@neovimPlugin.nvim-treesitter@" .. "/parser",
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = true,
        },
    })
    local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
    ft_to_parser.xml = "html"

    require("vim.treesitter.query").set_query(
        "beancount",
        "highlights",
        [[

(date) @field
(txn) @attribute

(account) @type

(amount) @number
(incomplete_amount) @number
(compound_amount) @number
(amount_tolerance) @number

(currency) @property

(key) @label
(string) @string
(payee) @string
(narration) @string

(tag) @constant
(link) @constant

(comment) @comment

[
    (balance) (open) (close) (commodity) (pad)
    (event) (price) (note) (document) (query)
    (custom) (pushtag) (poptag) (pushmeta)
    (popmeta) (option) (include) (plugin)
] @keyword
]]
    )
end

local treesitter_playground_spec = {
    name = "nvim-treesitter-playground",
    dir = "@neovimPlugin.nvim-treesitter-playground@",
    lazy = false,
}

return {
    treesitter_spec,
    treesitter_playground_spec,
}
