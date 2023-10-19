local python_lsp_cmd = "pylsp"
--local python_lsp_cmd = "pyright"

-- Check if lsp-server is available
if vim.fn.executable(python_lsp_cmd) ~= 1 then
    return
end

local config = {
    name = "pylsp",
    --name = "pyright",
    cmd = { python_lsp_cmd },
    filetypes = { "python" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", "setup.py", "setup.cfg", "pyproject.toml" }, { upward = true })[1]),
    capabilities = require("polarmutex.lsp").make_client_capabilities(),
    -- pylsp
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                ruff = { enabled = true, extendSelect = { "I" } },
                pydocstyle = { enabled = true },
            },
        },
    },
}

vim.lsp.start(config, {
    reuse_client = function(client, conf)
        return client.name == conf.name and client.config.root_dir == conf.root_dir
    end,
})
