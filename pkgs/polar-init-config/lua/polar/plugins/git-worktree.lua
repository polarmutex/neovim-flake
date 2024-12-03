-- local gwt = require("git-worktree")
--gwt.setup({})

require("telescope").load_extension("git_worktree")

local Hooks = require("git-worktree.hooks")
Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)

return {}
