-- require("polar.core.ui.statusline")
-- require("polar.core.ui.winbar")
-- require("polar.core.ui.statuscolumn")

require("polar.config.options")
require("polar.config.keymaps")
require("polar.config.autocmds")

require("polar.lazy").finish()

require("polar.utils.format").setup()

require("polar.lsp").setup()

require("polar.health").loaded = true
