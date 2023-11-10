local opts = {
    top = {
        {
            ft = "gitcommit",
            size = { height = 0.5 },
            wo = { signcolumn = "yes:2" },
        },
    },
    bottom = {
        {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(_, win)
                return vim.api.nvim_win_get_config(win).relative == ""
            end,
        },
        "Trouble",
        {
            ft = "qf",
            title = "QuickFix",
        },
        {
            ft = "help",
            size = { height = 20 },
            filter = function(buf)
                return vim.bo[buf].buftype == "help"
            end,
        },
        {
            ft = "NeogitStatus",
            size = { height = 0.3 },
            wo = { signcolumn = "yes:2" },
        },
        --      {
        --        title = "Neotest Output";
        --        ft = "neotest-output-panel";
        --        size = {height = 15;};
        --      }
    },
    left = {
        --      {
        --        title = "Neotest Summary";
        --        ft = "neotest-summary";
        --      }
    },
    exit_when_last = true,
}
require("edgy").setup(opts)
