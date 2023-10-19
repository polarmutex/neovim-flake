local M = {}

--- Get a list of registered null-ls providers for a given filetype
---@param filetype string the filetype to search null-ls for
---@return table # a table of null-ls sources
function M.providers(filetype)
    local registered = {}
    -- try to load null-ls
    local sources_avail, sources = pcall(require, "null-ls.sources")
    if sources_avail then
        -- get the available sources of a given filetype
        for _, source in ipairs(sources.get_available(filetype)) do
            -- get each source name
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end
    end
    -- return the found null-ls sources
    return registered
end

--- Get the null-ls sources for a given null-ls method
---@param filetype string the filetype to search null-ls for
---@param method string the null-ls method (check null-ls documentation for available methods)
---@return string[] # the available sources for the given filetype and method
function M.sources(filetype, method)
    local methods_avail, methods = pcall(require, "null-ls.methods")
    return methods_avail and M.providers(filetype)[methods.internal[method]] or {}
end

return M
