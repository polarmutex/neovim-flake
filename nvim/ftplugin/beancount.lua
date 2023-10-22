--local lsp_cmd = "beancount-language-server"
local lsp_cmd = "/home/polar/repos/personal/beancount-language-server/main/target/release/beancount-language-server"
--local lsp_cmd = "/home/polar/repos/personal/beancount-language-server/develop/target/release/beancount-language-server"

-- Check if lsp-server is available
if vim.fn.executable(lsp_cmd) ~= 1 then
    return
end

local config = {
    name = "beancount-lsp",
    cmd = {
        lsp_cmd,
        --"--log"
    },
    filetypes = { "beancount" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
    capabilities = require("polarmutex.lsp").make_client_capabilities(),
    single_file_support = true,
    init_options = {
        journal_file = "~/repos/personal/beancount/main/main.beancount",
    },
    settings = {},
}

vim.lsp.start(config, {
    reuse_client = function(client, conf)
        return client.name == conf.name and client.config.root_dir == conf.root_dir
    end,
})

require("telescope").load_extension("beancount")

local map = vim.keymap.set
map("n", "<Leader>mc", "<cmd>%s/txn/*/gc<CR>", {
    desc = "beancount-nvim: mark transactions as reconciled",
    noremap = true,
    silent = true,
})
map("n", "<Leader>mt", function()
    require("telescope").extensions.beancount.copy_transactions(require("telescope.themes").get_ivy({}))
end, {
    desc = "Telescope: beancount: copy beancount transactions",
    noremap = true,
    silent = true,
})
