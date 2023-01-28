---@mod polarmutex.plugins.gitsigns Gitsigns
---@brief [[
-- keymaps
-- gb = { "<cmd>Gitsigns blame_line", "Blame line" },
-- gc = { "<cmd>Gitsigns next_hunk", "Next hunk" },
-- gn = { "<cmd>Gitsigns next_hunk", "Next hunk" },
--  gp = { "<cmd>Gitsigns prev_hunk", "Prev hunk" },
--  gs = { "<cmd>Gitsigns preview_hunk", "Preview hunk" },
---@brief ]]

local diffview_spec = {
    name = "diffview.nvim",
    dir = "@neovimPlugin.diffview-nvim@",
    event = "CursorHold",
}

diffview_spec.config = function()
    require("diffview").setup()
end

local gitsigns_spec = {
    name = "gitsigns.nvim",
    dir = "@neovimPlugin.gitsigns-nvim@",
    event = "BufRead",
}

gitsigns_spec.config = function()
    require("gitsigns").setup({})
end

local gitworktree_spec = {
    name = "gitworktree.nvim",
    --dir = "@neovimPlugin.gitworktree-nvim@",
    dir = "~/repos/personal/git-worktree-nvim/master",
    event = "BufRead",
}

gitworktree_spec.config = function()
    require("git-worktree").setup({})
    require("telescope").load_extension("git_worktree")
end

local neogit_spec = {
    name = "neogit",
    dir = "@neovimPlugin.neogit@",
    lazy = false,
}

neogit_spec.config = function()
    require("neogit").setup({
        kind = "split",
        disable_builtin_notifications = true,
        signs = {
            section = { "", "" },
            item = { "", "" },
        },

        integrations = {
            diffview = true,
        },
    })
end

return {
    diffview_spec,
    gitsigns_spec,
    gitworktree_spec,
    neogit_spec,
}
