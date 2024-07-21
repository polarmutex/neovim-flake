local wk = require("which-key")
wk.setup()

-- Document existing key chains
wk.register({
    ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
    ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
    ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
})

-- visual mode
wk.register({
    ["<leader>h"] = { "Git [H]unk" },
}, { mode = "v" })
