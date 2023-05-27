local tokyonight_spec = {
    name = "tokyonight-nvim",
    dir = "@neovimPlugin.tokyonight-nvim@",
    lazy = false,
    priority = 1000,
}

tokyonight_spec.config = function()
    require("tokyonight").setup({
        style = "moon",
        transparent = false,
        on_highlights = function(hl, c)
            hl.CursorLineNr = { fg = c.orange, bold = true }
            hl.LineNr = { fg = c.orange, bold = true }
            hl.LineNrAbove = { fg = c.fg_gutter }
            hl.LineNrBelow = { fg = c.fg_gutter }
            local prompt = "#2d3149"
            hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
            hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
            hl.TelescopePromptNormal = { bg = prompt }
            hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
            hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
            hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
            hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
    })
    vim.cmd([[colorscheme tokyonight]])
end

local colorizer_spec = {
    dir = "@neovimPlugin.nvim-colorizer@",
    event = "CursorHold",
    config = function()
        require("colorizer").setup()
    end,
}

return {
    colorizer_spec,
    tokyonight_spec,
}
