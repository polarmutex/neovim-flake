-- local python_lsp_cmd = "pylsp"
local lsp_cmd = "vtsls"

-- Check if lsp-server is available
if vim.fn.executable(lsp_cmd) ~= 1 then
    return
end

local config = {
    cmd = { "vtsls", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "tsconfig.json", "package.json", "jsconfig.json", ".git" }, { upward = true })[1]
    ),
    single_file_support = true,
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
}

vim.lsp.start(config, {
    reuse_client = function(client, conf)
        return client.config.root_dir == conf.root_dir
    end,
})

require("dap-python").setup()
