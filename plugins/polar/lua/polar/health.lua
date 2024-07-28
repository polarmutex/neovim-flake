local M = {}

--- Run by checkhealt
local health = vim.health or require("health")
function M.check()
    health.report_ok("OK")
end

return M
