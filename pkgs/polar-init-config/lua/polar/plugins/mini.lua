local MSL = {}

local mini_sl = require("mini.statusline")

MSL.setup = function()
    -- H.create_diagnostic_hl() -- added diagnostics with colors
    -- H.require_markerline()
    mini_sl.setup({
        use_icons = true,
        set_vim_settings = true,
        content = { active = MSL.active }, -- entrypoint
    })
    -- H.create_autocommands() -- lsp autocommands for custom lsp section
    -- H.set_active() -- lazy loading, missing events, still show statusline
end

-- LSP clients of all buffers
-- Mark (e.g., using green color) the clients attaching to the current buffer
-- function MSL.lsp_component(trunc_width)
--     local clients = vim.lsp.get_clients()
--     local client_names = {}
--     for _, client in ipairs(clients) do
--         if client and client.name ~= "" then
--             local attached_buffers = client.attached_buffers
--             if attached_buffers[vim.api.nvim_get_current_buf()] then
--                 table.insert(client_names, string.format("%%#StlComponentOn#%s%%*", client.name))
--             else
--                 table.insert(client_names, client.name)
--             end
--         end
--     end
--     if next(client_names) == nil then
--         return "%#StlComponentInactive#[LS Inactive]%*"
--     end
--     return string.format("[%s]", table.concat(client_names, ", "))
-- end

-- function MSL.lint_component(trunc_width)
--     local linters = require("lint").get_running()
--     return string.format("[%s]", table.concat(linters, ", "))
-- end

-- Treesitter status
-- Use different colors to denote whether it has a parser for the
-- current file and whether the highlight is enabled:
-- * gray  : no parser
-- * green : has parser and highlight is enabled
-- * red   : has parser but highlight is disabled
-- function MSL.treesitter_component()
--     local res = icons.misc.tree
--     local buf = vim.api.nvim_get_current_buf()
--     local hl_enabled = vim.treesitter.highlighter.active[buf]
--     local has_parser = vim.treesitter.get_parser(buf, vim.bo.filetype, { error = false }) ~= nil
--     if not has_parser then
--         return string.format("%%#StlComponentInactive#%s%%*", res)
--     end
--     local format_str = hl_enabled and "%%#StlComponentOn#%s%%*" or "%%#StlComponentOff#%s%%*"
--     return string.format(format_str, res)
-- end

-- overridden: removed filesize
MSL.section_fileinfo = function(args)
    local filetype = vim.bo.filetype
    -- Don't show anything if no filetype or not inside a "normal buffer"
    if filetype == "" or vim.bo.buftype ~= "" then
        return ""
    end

    -- Construct output string if truncated
    if mini_sl.is_truncated(args.trunc_width) then
        return filetype
    end

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = vim.bo.fileformat
    return string.format("%s %s[%s]", filetype, encoding, format)
end

-- overridden: changed delimiters
MSL.section_location = function(args)
    -- Use virtual column number to allow update when past last column
    if mini_sl.is_truncated(args.trunc_width) then
        return "%l│%2v"
    end

    -- Use `virtcol()` to correctly handle multi-byte characters
    return '%l|%L %2v|%-2{virtcol("$") - 1}'
end

MSL.active = function() -- entrypoint
    local mode, mode_hl = mini_sl.section_mode({ trunc_width = 120 })
    local git = mini_sl.section_git({ trunc_width = 40, icon = "" })
    -- local diff = mini_sl.section_diff({ trunc_width = 75, icon = "" })
    local diagnostics = mini_sl.section_diagnostics({ trunc_width = 75 })
    local lsp = mini_sl.section_lsp({ trunc_width = 75 })
    -- local filename = mini_sl.section_filename({ trunc_width = 140 })
    local fileinfo = MSL.section_fileinfo({ trunc_width = 120 })
    local location = MSL.section_location({ trunc_width = 75 })
    local search = mini_sl.section_searchcount({ trunc_width = 75 })

    -- diff = diff and diff:sub(2) or diff -- remove first space
    -- lsp = lsp and #lsp > 0 and " " or ""
    -- diag = diag and diag:sub(2) or diag -- remove first space

    return mini_sl.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { lsp, diagnostics } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFilename", strings = { search } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { location } },
        -- { hl = mode_hl, strings = { mode } },
        -- { hl = H.marker_highlight(), strings = { marker_data } },
        -- { hl = H.fixed_hl, strings = { git, diff } },
        -- { hl = H.fixed_hl, strings = { lsp, diag } },
        -- "%<", -- Mark general truncate point
        -- { hl = H.fixed_hl, strings = { filename } },
        -- "%=", -- End left alignment
        -- { hl = "MiniStatuslineModeCommand", strings = { macro } },
        -- { hl = H.fixed_hl, strings = { fileinfo } },
        -- { hl = mode_hl, strings = { search, location } },
    })
end

return {
    {
        "mini-nvim",
        event = "DeferredUIEnter",
        after = function()
            MSL.setup()
        end,
    },
}
