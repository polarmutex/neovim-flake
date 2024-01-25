local gwt = require("git-worktree")
local Hooks = require("git-worktree.hooks")
gwt:setup({})

require("telescope").load_extension("git_worktree")

gwt:hooks({
    SWITCH = Hooks.builtins.update_current_buffer_on_switch,
})
