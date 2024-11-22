require("kanagawa").setup({
    commentStyle = { italic = true },
    theme = "wave",
})

require("tokyonight").setup({
    style = "moon",
    transparent = false,
    ---@param highlights tokyonight.Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors)
        highlights["StlModeNormal"] = { fg = colors.black, bg = colors.blue, bold = true }
        highlights["StlModeInsert"] = { fg = colors.black, bg = colors.green, bold = true }
        highlights["StlModeVisual"] = { fg = colors.black, bg = colors.magenta, bold = true }
        highlights["StlModeReplace"] = { fg = colors.black, bg = colors.red, bold = true }
        highlights["StlModeCommand"] = { fg = colors.black, bg = colors.yellow, bold = true }
        highlights["StlModeTerminal"] = { fg = colors.black, bg = colors.green1, bold = true }
        highlights["StlModePending"] = { fg = colors.black, bg = colors.red, bold = true }

        highlights["StlModeSepNormal"] = { fg = colors.blue, bg = colors.bg_statusline }
        highlights["StlModeSepInsert"] = { fg = colors.green, bg = colors.bg_statusline }
        highlights["StlModeSepVisual"] = { fg = colors.magenta, bg = colors.bg_statusline }
        highlights["StlModeSepReplace"] = { fg = colors.red, bg = colors.bg_statusline }
        highlights["StlModeSepCommand"] = { fg = colors.yellow, bg = colors.bg_statusline }
        highlights["StlModeSepTerminal"] = { fg = colors.green1, bg = colors.bg_statusline }
        highlights["StlModeSepPending"] = { fg = colors.red, bg = colors.bg_statusline }

        highlights["StlIcon"] = { fg = colors.fg, bg = colors.bg_statusline }

        highlights["StlComponentInactive"] = { fg = colors.bg_statusline, bg = colors.bg_statusline }
        highlights["StlComponentOn"] = { fg = colors.green, bg = colors.bg_statusline }
        highlights["StlComponentOff"] = { fg = colors.red, bg = colors.bg_statusline }

        highlights["StlDiagnosticError"] = { fg = colors.error, bg = colors.bg_statusline }
        highlights["StlDiagnosticWarn"] = { fg = colors.warning, bg = colors.bg_statusline }
        highlights["StlDiagnosticInfo"] = { fg = colors.info, bg = colors.bg_statusline }
        highlights["StlDiagnosticHint"] = { fg = colors.hint, bg = colors.bg_statusline }

        highlights["StlSearchCnt"] = { fg = colors.orange, bg = colors.bg_statusline }

        highlights["StlMacroRecording"] = "StlComponentOff"
        highlights["StlMacroRecorded"] = "StlComponentOn"

        highlights["StlFiletype"] = { fg = colors.fg, bg = colors.bg_statusline }

        highlights["StlLocComponent"] = "StlModeNormal"
        highlights["StlLocComponentSep"] = "StlModeSepNormal"

        highlights["WinbarHeader"] = { fg = colors.fg, bg = colors.blue0 }
        highlights["WinbarTriangleSep"] = { fg = colors.blue0 }
        highlights["WinbarModified"] = { fg = colors.fg, bg = colors.bg }
        highlights["WinbarError"] = { fg = colors.error, bg = colors.bg }
        highlights["WinbarWarn"] = { fg = colors.warning, bg = colors.bg }
        highlights["WinbarSpecialIcon"] = { fg = colors.fg, bg = colors.bg }
        highlights["WinbarPathPrefix"] = { fg = colors.fg, bg = colors.bg, bold = true }
    end,
})

-- vim.cmd([[colorscheme kanagawa]])
vim.cmd([[colorscheme tokyonight]])

return {}
