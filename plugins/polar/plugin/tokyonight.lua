require("tokyonight").setup({
    style = "moon",
    transparent = false,
    ---@param highlights tokyonight.Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors)
        highlights["StlModeNormal"] = { fg = colors.black, bg = colors.blue }
        highlights["StlModeInsert"] = { fg = colors.black, bg = colors.green }
        highlights["StlModeVisual"] = { fg = colors.black, bg = colors.magenta }
        highlights["StlModeReplace"] = { fg = colors.black, bg = colors.red }
        highlights["StlModeCommand"] = { fg = colors.black, bg = colors.yellow }
        highlights["StlModeTerminal"] = { fg = colors.black, bg = colors.green1 }
        highlights["StlModePending"] = { fg = colors.black, bg = colors.red }

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
    end,
})
vim.cmd([[colorscheme tokyonight]])
