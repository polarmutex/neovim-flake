local nullls_utils = require("polarmutex.utils.null-ls")

local noice_spec = {
    name = "noice.nvim",
    dir = "@neovimPlugin.noice-nvim@",
    dependencies = {
        { name = "nui.nvim", dir = "@neovimPlugin.nui-nvim@" },
    },
    lazy = false,
}

noice_spec.config = function()
    require("noice").setup()
end

local statusline_spec = {
    name = "heirline.nvim",
    dir = "@neovimPlugin.heirline-nvim@",
    lazy = false,
}

statusline_spec.config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local function setup_colors()
        return {
            bright_bg = utils.get_highlight("Folded").bg,
            red = utils.get_highlight("DiagnosticError").fg,
            dark_red = utils.get_highlight("DiffDelete").bg,
            green = utils.get_highlight("String").fg,
            blue = utils.get_highlight("Function").fg,
            gray = utils.get_highlight("NonText").fg,
            orange = utils.get_highlight("Constant").fg,
            purple = utils.get_highlight("Statement").fg,
            cyan = utils.get_highlight("Special").fg,
            diag_warn = utils.get_highlight("DiagnosticWarn").fg,
            diag_error = utils.get_highlight("DiagnosticError").fg,
            diag_hint = utils.get_highlight("DiagnosticHint").fg,
            diag_info = utils.get_highlight("DiagnosticInfo").fg,
            --git_del = utils.get_highlight("diffDeleted").fg,
            --git_add = utils.get_highlight("diffAdded").fg,
            --git_change = utils.get_highlight("diffChanged").fg,
        }
    end

    require("heirline").load_colors(setup_colors())

    --
    -- VI Mode
    --
    local ViMode = {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        static = {
            mode_names = {
                n = "N",
                no = "N?",
                nov = "N?",
                noV = "N?",
                ["no\22"] = "N?",
                niI = "Ni",
                niR = "Nr",
                niV = "Nv",
                nt = "Nt",
                v = "V",
                vs = "Vs",
                V = "V_",
                Vs = "Vs",
                ["\22"] = "^V",
                ["\22s"] = "^V",
                s = "S",
                S = "S_",
                ["\19"] = "^S",
                i = "I",
                ic = "Ic",
                ix = "Ix",
                R = "R",
                Rc = "Rc",
                Rx = "Rx",
                Rv = "Rv",
                Rvc = "Rv",
                Rvx = "Rv",
                c = "C",
                cv = "Ex",
                r = "...",
                rm = "M",
                ["r?"] = "?",
                ["!"] = "!",
                t = "T",
            },
        },
        provider = function(self)
            return " %2(" .. self.mode_names[self.mode] .. "%)"
        end,
        hl = function(self)
            local color = self:mode_color()
            return { fg = color, bold = true }
        end,
    }

    local Snippets = {}

    ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode, Snippets })

    local FileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color =
                require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end,
    }

    local FileName = {
        init = function(self)
            self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
            if self.lfilename == "" then
                self.lfilename = "[No Name]"
            end
            if not conditions.width_percent_below(#self.lfilename, 0.27) then
                self.lfilename = vim.fn.pathshorten(self.lfilename)
            end
        end,
        hl = "Directory",

        flexible = 2,
        {
            provider = function(self)
                return self.lfilename
            end,
        },
        {
            provider = function(self)
                return vim.fn.pathshorten(self.lfilename)
            end,
        },
    }

    local FileFlags = {
        {
            provider = function()
                if vim.bo.modified then
                    return "[+]"
                end
            end,
            hl = { fg = "green" },
        },
        {
            provider = function()
                if not vim.bo.modifiable or vim.bo.readonly then
                    return ""
                end
            end,
            hl = "Constant",
        },
    }

    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                return { fg = "cyan", bold = true, force = true }
            end
        end,
    }

    FileNameBlock = utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), unpack(FileFlags))

    local FileType = {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
        hl = "Type",
    }

    local Ruler = {
        -- %l = current line number
        -- %L = number of lines in the buffer
        -- %c = column number
        -- %P = percentage through file of displayed window
        provider = "%7(%l/%3L%):%2c %P",
    }

    local WorkDir = {
        provider = function(self)
            self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
            local cwd = vim.fn.getcwd(0)
            self.cwd = vim.fn.fnamemodify(cwd, ":~")
            if not conditions.width_percent_below(#self.cwd, 0.27) then
                self.cwd = vim.fn.pathshorten(self.cwd)
            end
        end,
        hl = { fg = "blue", bold = true },

        flexible = 1,
        {
            provider = function(self)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return self.icon .. self.cwd .. trail .. " "
            end,
        },
        {
            provider = function(self)
                local cwd = vim.fn.pathshorten(self.cwd)
                local trail = self.cwd:sub(-1) == "/" and "" or "/"
                return self.icon .. cwd .. trail .. " "
            end,
        },
        {
            provider = "",
        },
    }

    local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0
                or self.status_dict.removed ~= 0
                or self.status_dict.changed ~= 0
        end,
        hl = { fg = "orange" },

        {
            provider = function(self)
                return " " .. self.status_dict.head
            end,
            hl = { bold = true },
        },
    }

    local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },

        --provider = " [LSP]",

        -- Or complicate things a bit and get the servers names
        -- TODO get name from null-ls
        provider = function()
            local names = {}
            for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                if client.name == "null-ls" then
                    local null_ls_sources = {}
                    for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                        for _, source in ipairs(nullls_utils.sources(vim.bo.filetype, type)) do
                            null_ls_sources[source] = true
                        end
                    end
                    vim.list_extend(names, vim.tbl_keys(null_ls_sources))
                else
                    table.insert(names, client.name)
                end
            end
            return " [" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = "green", bold = true },
        on_click = {
            name = "heirline_LSP",
            callback = function()
                vim.defer_fn(function()
                    vim.cmd("LspInfo")
                end, 100)
            end,
        },
    }

    local Diagnostics = {

        condition = conditions.has_diagnostics,
        update = { "DiagnosticChanged", "BufEnter" },
        on_click = {
            callback = function()
                require("trouble").toggle({ mode = "document_diagnostics" })
            end,
            name = "heirline_diagnostics",
        },

        static = {
            error_icon = "",
            warn_icon = "",
            info_icon = "",
            hint_icon = "",
        },

        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        {
            provider = function(self)
                return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
            end,
            hl = "DiagnosticError",
        },
        {
            provider = function(self)
                return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
            end,
            hl = "DiagnosticWarn",
        },
        {
            provider = function(self)
                return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
            end,
            hl = "DiagnosticInfo",
        },
        {
            provider = function(self)
                return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
            end,
            hl = "DiagnosticHint",
        },
    }

    local DAPMessages = {
        condition = function()
            local session = require("dap").session()
            if session then
                local filename = vim.api.nvim_buf_get_name(0)
                if session.config then
                    local progname = session.config.program
                    return filename == progname
                end
            end
            return false
        end,
        provider = function()
            return " " .. require("dap").status()
        end,
        hl = "Debug",
        --       ﰇ  
    }

    local HelpFilename = {
        condition = function()
            return vim.bo.filetype == "help"
        end,
        provider = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = "Directory",
    }

    --local Spell = {
    --    condition = function()
    --        return vim.wo.spell
    --    end,
    --    provider = "SPELL ",
    --    hl = { bold = true, fg = "orange" },
    --}

    local Align = { provider = "%=" }
    local Space = { provider = " " }

    local DefaultStatusline = {
        ViMode,
        Space,
        WorkDir,
        FileNameBlock,
        { provider = "%<" },
        Space,
        Git,
        Space,

        Align,
        DAPMessages,

        Align,

        Diagnostics,
        Space,
        LSPActive,
        Space,
        FileType,
        Space,
        Ruler,
    }

    local SpecialStatusline = {
        condition = function()
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                filetype = { "^git.*", "fugitive" },
            })
        end,
        FileType,
        { provider = "%q" },
        Space,
        HelpFilename,
        Align,
    }

    local GitStatusline = {
        condition = function()
            return conditions.buffer_matches({
                filetype = { "^git.*", "fugitive" },
            })
        end,
        FileType,
        Space,
        {
            provider = function()
                return vim.fn.FugitiveStatusline()
            end,
        },
        Space,
        Align,
    }

    local StatusLines = {

        hl = function()
            if conditions.is_active() then
                return "StatusLine"
            else
                return "StatusLineNC"
            end
        end,

        static = {
            mode_colors = {
                n = "red",
                i = "green",
                v = "cyan",
                V = "cyan",
                ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
                c = "orange",
                s = "purple",
                S = "purple",
                ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
                R = "orange",
                r = "orange",
                ["!"] = "red",
                t = "green",
            },
            mode_color = function(self)
                local mode = conditions.is_active() and vim.fn.mode() or "n"
                return self.mode_colors[mode]
            end,
        },

        fallback = false,

        GitStatusline,
        SpecialStatusline,
        DefaultStatusline,
    }

    local WinBar = {
        fallback = false,
        {
            condition = function()
                return conditions.buffer_matches({
                    buftype = { "nofile", "prompt", "help", "quickfix" },
                    filetype = { "^git.*", "fugitive" },
                })
            end,
            init = function()
                vim.opt_local.winbar = nil
            end,
        },
        utils.surround({ "", "" }, "bright_bg", {
            hl = function()
                if not conditions.is_active() then
                    return { fg = "gray", force = true }
                end
            end,

            FileNameBlock,
        }),
    }

    local Stc = {
        {
            provider = "%s",
            static = {
                resolve = function(self, name)
                    for pat, cb in pairs(self.handlers) do
                        if name:match(pat) then
                            return cb
                        end
                    end
                end,

                handlers = {
                    ["GitSigns.*"] = function(_)
                        require("gitsigns").preview_hunk_inline()
                    end,
                    ["Dap.*"] = function(_)
                        require("dap").toggle_breakpoint()
                    end,
                    ["Diagnostic.*"] = function(_)
                        vim.diagnostic.open_float() -- { pos = args.mousepos.line - 1, relative = "mouse" })
                    end,
                },
            },
            on_click = {
                callback = function(self)
                    local mousepos = vim.fn.getmousepos()
                    vim.api.nvim_win_set_cursor(0, { mousepos.line, mousepos.column })
                    local sign_at_cursor = vim.fn.screenstring(mousepos.screenrow, mousepos.screencol)
                    if sign_at_cursor ~= "" then
                        local args = {
                            mousepos = mousepos,
                        }
                        local signs = vim.fn.sign_getdefined()
                        for _, sign in ipairs(signs) do
                            local glyph = sign.text:gsub(" ", "")
                            if sign_at_cursor == glyph then
                                vim.defer_fn(function()
                                    self:resolve(sign.name)(args)
                                end, 10)
                                return
                            end
                        end
                    end
                end,
                name = "heirline_signcol_callback",
                update = true,
            },
        },
        {
            provider = "%=%4{v:wrap ? '' : &nu ? (&rnu && v:relnum ? v:relnum : v:lnum) : ''}",
        },
        {
            provider = "%C ",
        },
    }

    require("heirline").setup({
        statusline = StatusLines,
        winbar = WinBar,
        statuscolumn = Stc,
        --tabline
    })
    vim.o.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s" --require("heirline").eval_statuscolumn()

    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        pattern = "HeirlineInitWinbar",
        callback = function(args)
            local buf = args.buf
            local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
            local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
            if buftype or filetype then
                vim.opt_local.winbar = nil
            end
        end,
        group = "Heirline",
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            require("heirline").reset_highlights()
            require("heirline").load_colors(setup_colors())
            require("heirline").statusline:broadcast(function(self)
                self._win_stl = nil
            end)
        end,
        group = "Heirline",
    })
end

local web_devicons_spec = {
    name = "nvim-web-devicons",
    dir = "@neovimPlugin.nvim-web-devicons@",
    lazy = false,
}

return {
    noice_spec,
    statusline_spec,
    web_devicons_spec,
}
