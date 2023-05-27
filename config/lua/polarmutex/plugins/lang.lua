local crates_spec = {
    dir = "@neovimPlugin.crates-nvim@",
    ft = "rust",
}

crates_spec.config = function()
    require("crates").setup()
end

local neodev_spec = {
    dir = "@neovimPlugin.neodev-nvim@",
    module = "neodev",
    ft = "lua",
}

local rust_tools_spec = {
    dir = "@neovimPlugin.rust-tools-nvim@",
    -- dependencies = { use("neovim/nvim-lspconfig") },
    ft = "rust",
}

rust_tools_spec.config = function()
    --local extension_path = vim.fn.stdpath("data") .. "/vscode-lldb/"
    --local codelldb_path = extension_path .. "adapter/codelldb"
    --local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    --require("rust-tools").setup({
    --server = {
    --  on_attach = require("plugins.lsp.on_attach"),
    --},
    --dap = {
    --  adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    --},
    --})
end

return {
    crates_spec,
    neodev_spec,
    rust_tools_spec,
}
