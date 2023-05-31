local overseer_nvim_spec = {
    name = "overseer-nvim",
    dir = "@neovimPlugin.overseer-nvim@",
    dependencies = {},
    lazy = false,
}

overseer_nvim_spec.config = function()
    --local Path = require("plenary.path")
    require("overseer").setup({
        task_list = {
            direction = "bottom",
        },
        templates = { "builtin", "conan" },
    })
end

return {
    overseer_nvim_spec,
}
