---@mod polarmutex.plugins.overseer overseer-nvim
local tasks_nvim_spec = {
    name = "tasks.nvim",
    --dir = "@neovimPlugin.tasks-nvim@",
    dir = "/home/polar/repos/personal/tasks.nvim/main",
    dependencies = {},
    lazy = false,
}

tasks_nvim_spec.config = function()
    --local Path = require("plenary.path")
    require("tasks").setup({
        default_params = {},
        save_before_run = true, -- If true, all files will be saved before executing a task.
        quickfix = {
            pos = "botright", -- Default quickfix position.
            height = 12, -- Default height.
            only_on_error = true,
        },
        dap_open_command = function()
            return require("dap").repl.open()
        end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
    })
end

local M = {
    tasks_nvim_spec,
}
return M
