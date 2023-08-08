local Util = require("lazy.core.util")

local M = {}

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param name string
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

local enabled = true
function M.toggle_diagnostics()
    enabled = not enabled
    if enabled then
        vim.diagnostic.enable()
        Util.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        Util.warn("Disabled diagnostics", { title = "Diagnostics" })
    end
end

-- Find either the Nix-generated version of the plugin if it is
-- found, or fall back to fetching it remotely if it is not.
-- Don't mistake this for "use" from packer.nvim
M.use = function(name, spec)
    spec = spec or {}
    local plugin_name = name:match("[^/]+$")
    local plugin_dir = vim.fn.stdpath("data") .. "/plugins/" .. plugin_name
    if vim.fn.isdirectory(plugin_dir) > 0 then
        spec["dir"] = plugin_dir
    else
        spec[1] = name
    end
    return spec
end

return M
