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
    event = "BufReadPost",
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
end

return {
    treesitter_spec,
}
