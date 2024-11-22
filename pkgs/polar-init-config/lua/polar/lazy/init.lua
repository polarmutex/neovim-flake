local M = {}

M.finish = function()
    require("lz.n").load("polar/plugins")
end

M.packadd = function(name)
    vim.api.nvim_cmd({
        cmd = "packadd",
        args = { name },
    }, {})
end

M.load_once = function(name)
    -- local state = require("lz.n.state").plugins
    require("lz.n").trigger_load(name)

    for _, v in ipairs(require("lz.n.state").plugins) do
        vim.notify(v)

        if v == name then
            table.remove(require("lz.n.state").plugins, name)
            break
        end
    end
end

return M
