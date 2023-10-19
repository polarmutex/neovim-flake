local rust_lsp_cmd = "rust-analyzer"

-- Check if available
if vim.fn.executable(rust_lsp_cmd) ~= 1 then
    return
end

local root_files = {
    "Cargo.toml",
    ".git",
}

local function register_cap()
    local capabilities = require("polarmutex.lsp").make_client_capabilities()
    capabilities.experimental = {
        serverStatusNotification = true,
    }
    return capabilities
end

vim.lsp.start({
    name = "rust-analyzer",
    cmd = { rust_lsp_cmd },
    filetypes = { "rust" },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = register_cap(),
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})
