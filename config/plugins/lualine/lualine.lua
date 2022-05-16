local function clock()
    return " " .. os.date("%H:%M")
end

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local config = {
    options = {
        theme = "tokyonight",
        --section_separators = { left = "", right = "" },
        --component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        icons_enabled = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "branch",
                condition = conditions.check_git_workspace,
            }
        },
        lualine_c = {
            { "diagnostics", sources = { "nvim_diagnostic" } },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            --{
            --    function()
            --        local gps = require("nvim-gps")
            --        return gps.get_location()
            --    end,
            --    cond = function()
            --        local gps = require("nvim-gps")
            --        return pcall(require, "nvim-treesitter.parsers") and gps.is_available()
            --    end,
            --    color = { fg = "#ff9e64" },
            --},
        },
        lualine_y = {
            {
                -- Lsp server name .
                function()
                    local msg = "No Active Lsp"
                    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = " LSP:",
                color = { fg = "#ffffff", gui = "bold" },
            }
        },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "nvim-tree" },
}

-- try to load matching lualine theme

local M = {}

function M.load()
    local name = vim.g.colors_name or ""
    local ok, _ = pcall(require, "lualine.themes." .. name)
    if ok then
        config.options.theme = name
    end
    require("lualine").setup(config)
end

M.load()

-- vim.api.nvim_exec([[
--   autocmd ColorScheme * lua require("config.lualine").load();
-- ]], false)

return M
