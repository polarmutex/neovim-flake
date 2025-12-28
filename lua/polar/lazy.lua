local M = {}

M.finish = function()
    require("lz.n").load("polar/plugins")
end

---@param name string
M.packadd = function(name)
    vim.api.nvim_cmd({
        cmd = "packadd",
        args = { name },
    }, {})
end

return M
