-- require("polar.base")
-- require("polar.visual")

local modules = {
    "autocmds",
    --"commands",
    --"filetypes",
    "keymaps",
    "lsp",
    "options",
}

for _, module in ipairs(modules) do
    local ok, mod = pcall(require, "polar." .. module)
    if not ok then
        print("Uh oh! The " .. module .. " module failed to load.")
    else
        mod.setup()
    end
end

require("polar.core.ui.statusline")
require("polar.core.ui.winbar")
require("polar.core.ui.statuscolumn")

require("polar.lazy").finish()

require("polar.health").loaded = true
