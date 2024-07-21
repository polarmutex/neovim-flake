-- Exit if the language server isn't available
if vim.fn.executable("nil") ~= 1 then
    return
end

local root_files = {
    "flake.nix",
    ".git",
}

vim.lsp.start({
    name = "nil_ls",
    cmd = { "nil" },
    filetypes = { "nix" },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = require("polarmutex.lsp").make_client_capabilities(),
    settings = {
        --formatting = {
        --    command = { "alejandra", "-qq" },
        --},
        flake = {
            autoArchive = true,
            autoEvalInputs = true,
        },
    },
})
