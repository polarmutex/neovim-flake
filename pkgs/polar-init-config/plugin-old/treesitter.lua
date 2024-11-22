vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
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
