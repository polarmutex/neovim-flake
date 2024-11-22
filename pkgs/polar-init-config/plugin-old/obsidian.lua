local obsidian = require("obsidian")
local Path = require("obsidian.path")

local ws = {}

local p = Path.new("~/repos/personal/obsidian-second-brain/main"):resolve()
if p:exists() then
    table.insert(ws, { name = "main", path = "~/repos/personal/obsidian-second-brain/main" })
end

if ws[1] ~= nil then
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    obsidian.setup({
        workspaces = ws,

        -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
        -- levels defined by "vim.log.levels.*".
        -- log_level = vim.log.levels.INFO,

        -- daily_notes = {
        --     -- Optional, if you keep daily notes in a separate directory.
        --     folder = "notes/dailies",
        --     -- Optional, if you want to change the date format for the ID of daily notes.
        --     date_format = "%Y-%m-%d",
        --     -- Optional, if you want to change the date format of the default alias of daily notes.
        --     alias_format = "%B %-d, %Y",
        --     -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        --     template = nil,
        -- },

        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 2,
        },

        -- Where to put new notes. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        -- new_notes_location = "notes_subdir",

        -- Optional, for templates (see below).
        -- templates = {
        --     subdir = "templates",
        --     date_format = "%Y-%m-%d",
        --     time_format = "%H:%M",
        --     -- A map for custom variables, the key should be the variable and the value a function
        --     substitutions = {},
        -- },

        -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
        -- open_app_foreground = false,

        -- Optional, sort search results by "path", "modified", "accessed", or "created".
        -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
        -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
        sort_by = "modified",
        sort_reversed = true,

        -- Optional, determines how certain commands open notes. The valid options are:
        -- 1. "current" (the default) - to always open in the current window
        -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
        -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
        -- open_notes_in = "current",
    })
end
