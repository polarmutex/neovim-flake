-- Exit if the language server isn't available
if vim.fn.executable("nixd") ~= 1 then
    return
end

local root_files = {
    "flake.nix",
    ".git",
}

vim.lsp.start({
    name = "nixd",
    cmd = { "nixd" },
    filetypes = { "nix" },
    single_file_support = true,
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = require("polar.lsp").make_client_capabilities(),
    settings = {
        formatting = {
            command = { "alejandra", "-qq" },
        },
        -- flake = {
        --     autoArchive = true,
        --     autoEvalInputs = true,
        -- },
    },
})
