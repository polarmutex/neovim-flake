require("nvim-treesitter.configs").setup({
    --parser_install_dir = "@neovimPlugin.nvim-treesitter@" .. "/parser",
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true,
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            --toggle_query_editor = "o",
            --toggle_hl_groups = "i",
            --toggle_injected_languages = "t",
            --toggle_anonymous_nodes = "a",
            --toggle_language_display = "I",
            --focus_language = "f",
            --unfocus_language = "F",
            --update = "R",
            --goto_node = "<cr>",
            --show_help = "?",
        },
    },
})
-- broken need to use treesitter register function
--local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
--ft_to_parser.xml = "html"

require("vim.treesitter.query").set(
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
