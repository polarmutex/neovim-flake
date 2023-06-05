local M = {}

M.config = function()
    for _, file in ipairs({ "servers", "handlers" }) do
        require("polarmutex.config.lsp." .. file)
    end
end

return M
