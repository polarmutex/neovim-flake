vim.g.navic_silence = true
require("polarmutex.utils").on_attach(function(client, buffer)
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, buffer)
    end
end)

local opts = {
    separator = " ",
    highlight = true,
    depth_limit = 5,
    icons = require("polarmutex.icons").kinds,
}
require("nvim-navic").setup(opts)
