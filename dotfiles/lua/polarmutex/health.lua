local M = {}

--- Run by checkhealt
-- TODO
local health = vim.health or require("health")
function M.check()
    local report_info = vim.fn["health#report_info"]
    print("active clients")
    for key, client in pairs(vim.lsp.get_active_clients()) do
        -- print("loading key "..key)
        local config = client.config
        vim.fn["health#report_start"]("State of " .. config.name)
        report_info("Working directory: " .. config.root_dir)
    end
    health.report_ok("OK")
end

function M.nix_check()
    M.nix_check_treesitter()
    M.nix_check_git()
end

function M.nix_check_treesitter()
    local NVIM_TREESITTER_MINIMUM_ABI = 13
    if vim.treesitter.language_version then
        if vim.treesitter.language_version < NVIM_TREESITTER_MINIMUM_ABI then
            print(
                "[ERROR] Neovim was compiled with tree-sitter runtime ABI version "
                    .. vim.treesitter.language_version
                    .. ".\n"
                    .. "nvim-treesitter expects at least ABI version "
                    .. NVIM_TREESITTER_MINIMUM_ABI
                    .. "\n"
                    .. "Please make sure that Neovim is linked against are recent tree-sitter runtime when building"
                    .. " or raise an issue at your Neovim packager. Parsers must be compatible with runtime ABI."
            )
        end
    end

    require("nvim-treesitter.query").invalidate_query_cache()

    -- Parser installation checks
    local function query_status(lang, query_group)
        local ok, err = pcall(require("nvim-treesitter.query").get_query, lang, query_group)
        if not ok then
            return "x", err
        elseif not err then
            return "."
        else
            return "✓"
        end
    end

    local error_collection = {}

    local parser_installation = { "Parser/Features H L F I J" }
    for _, parser_name in pairs(require("nvim-treesitter.info").installed_parsers()) do
        local installed = #vim.api.nvim_get_runtime_file("parser/" .. parser_name .. ".so", false)

        -- Only append information about installed parsers
        if installed >= 1 then
            local multiple_parsers = installed > 1 and "+" or ""
            local out = "  - "
                .. parser_name
                .. multiple_parsers
                .. string.rep(" ", 15 - (#parser_name + #multiple_parsers))
            for _, query_group in pairs(require("nvim-treesitter.query").built_in_query_groups) do
                local status, err = query_status(parser_name, query_group)
                out = out .. status .. " "
                if err then
                    table.insert(error_collection, { parser_name, query_group, err })
                end
            end
            table.insert(parser_installation, vim.fn.trim(out, " ", 2))
        end
    end
    local legend = [[
  Legend: H[ighlight], L[ocals], F[olds], I[ndents], In[j]ections
         +) multiple parsers found, only one will be used
         x) errors found in the query, try to run :TSUpdate {lang}]]
    table.insert(parser_installation, legend)
    -- Finally call the report function
    if #error_collection > 0 then
        print("The following errors have been detected:")
        for _, p in ipairs(error_collection) do
            local lang, type, err = unpack(p)
            local lines = {}
            table.insert(lines, lang .. "(" .. type .. "): " .. err)
            local files = vim.treesitter.query.get_query_files(lang, type)
            if #files > 0 then
                table.insert(lines, lang .. "(" .. type .. ") is concatenated from the following files:")
                for _, file in ipairs(files) do
                    local fd = io.open(file, "r")
                    if fd then
                        local ok, file_err = pcall(vim.treesitter.query.parse_query, lang, fd:read("*a"))
                        if ok then
                            table.insert(lines, '|    [OK]:"' .. file .. '"')
                        else
                            table.insert(lines, '| [ERROR]:"' .. file .. '", failed to load: ' .. file_err)
                        end
                        fd:close()
                    end
                end
            end
            print("[ERROR] " .. table.concat(lines, "\n"))
        end
    end
end

function M.nix_check_git()
    if vim.fn.executable("git") == 0 then
        print("`[ERROR] git` executable not found.", {
            "Install it with your package manager.",
            "Check that your `$PATH` is set correctly.",
        })
    end
end

return M
