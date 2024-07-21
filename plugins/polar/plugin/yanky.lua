--local mappings = mapping.get_defaults()
--mappings.i["<c-p>"] = nil
local opts = {
    highlight = { timer = 200 },
    --ring = { storage = "sqlite" },
    --picker = {
    --  telescope = {
    --    use_default_mappings = false,
    --    mappings = mappings,
    --  },
    --},
}
require("yanky").setup(opts)
