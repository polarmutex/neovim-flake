require("neogit").setup({
    kind = "split",
    signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
    },
    --TODO integrations = { diffview = true },
})

