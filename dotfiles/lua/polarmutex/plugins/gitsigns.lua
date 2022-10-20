-- keymaps
-- gb = { "<cmd>Gitsigns blame_line", "Blame line" },
-- gc = { "<cmd>Gitsigns next_hunk", "Next hunk" },
-- gn = { "<cmd>Gitsigns next_hunk", "Next hunk" },
--  gp = { "<cmd>Gitsigns prev_hunk", "Prev hunk" },
--  gs = { "<cmd>Gitsigns preview_hunk", "Preview hunk" },

local M = {}

function M.setup()
    require("gitsigns").setup({})
end

return M
