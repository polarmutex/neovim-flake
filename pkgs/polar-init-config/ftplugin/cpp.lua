local clangd_cmd = "clangd"

-- Check if lua-language-server is available
if vim.fn.executable(clangd_cmd) ~= 1 then
    return
end

local root_files = {
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
}

vim.lsp.start({
    name = "clangd",
    cmd = {
        clangd_cmd,
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    filetypes = { "cpp" },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = require("polar.lsp").make_client_capabilities(),
    --before_init = require("neodev.lsp").before_init,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
    settings = {},
})
