local nullls_utils = require("polarmutex.utils.null-ls")

local M = {}

local dap_section = {
    function()
        local msg = "{}"
        local status = require("dap").status()
        if status and string.len(status) > 0 then
            msg = msg .. " " .. status
        end
        return msg
    end,
    cond = function()
        local is_session_active = not not require("dap").session()
        return is_session_active
    end,
}

local lsp_active_section = {
    function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end

        local client_names = {}
        local active_client = false
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                active_client = true
                if not client_names[client.name] then
                    client_names[client.name] = 1
                end
            end
        end

        if active_client then
            local names = {}
            for name, _ in pairs(client_names) do
                if name == "null-ls" then
                    local null_ls_sources = {}
                    for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                        for _, source in ipairs(nullls_utils.sources(vim.bo.filetype, type)) do
                            null_ls_sources[source] = true
                        end
                    end
                    vim.list_extend(names, vim.tbl_keys(null_ls_sources))
                else
                    table.insert(names, name)
                end
            end
            return "LSP [" .. table.concat(names, ", ") .. "]"
        end

        return "LSP [ - ]"
    end,
    --icon = " ",
    color = { gui = "bold" },
}

M.setup = function()
    require("lualine").setup({
        options = {
            theme = "auto",
            globalstatus = true,
            disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
            --+-------------------------------------------------+--
            --| A | B | C                             X | Y | Z |--
            --+-------------------------------------------------+--
            lualine_a = {
                {
                    "mode",
                    color = { gui = "bold" },
                },
            },
            lualine_b = {
                "branch",
            },
            lualine_c = {},
            lualine_x = {
                dap_section,
            },
            lualine_y = {
                "searchcount",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                },
                lsp_active_section,
            },
            lualine_z = {
                { "filetype", icon_only = false, separator = "", padding = { left = 1, right = 1 } },
                { "location", padding = { left = 0, right = 1 } },
                "progress",
            },
        },
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
