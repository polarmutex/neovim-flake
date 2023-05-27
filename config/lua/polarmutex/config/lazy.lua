---@brief [[
--- This is PolarMutex's neovim config
---@brief ]]

---@toc polarmutex.contents

---@mod polarmutex.todo TODO
---@brief [[
--- - add nix check for nivm-treesiter and lspconfig
--- - add spellcheck
---@brief ]]

local M = {}

M.setup = function()
    local modules = {
        "options",
        "autocmds",
        "keymaps",
        --"commands",
        --"filetypes",
    }

    for _, module in ipairs(modules) do
        local ok, mod = pcall(require, "polarmutex.config." .. module)
        if not ok then
            print("Uh oh! The " .. module .. " module failed to load.")
        else
            mod.setup()
        end
    end

    local lazypath = "@neovimPlugin.lazy-nvim@"
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
        spec = {
            --{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "polarmutex.plugins" },
        },
        defaults = {
            -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
            -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
            lazy = true,
            -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
            -- have outdated releases, which may break your Neovim install.
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        install = {
            -- install missing plugins on startup. This doesn't increase startup time.
            missing = false,
            -- try to load one of these colorschemes when starting an installation during startup
            colorscheme = { "tokyonight" },
        },
        checker = { enabled = false }, -- automatically check for plugin updates
        performance = {
            reset_packpath = false,
            rtp = {
                -- disable some rtp plugins
                disabled_plugins = {
                    "gzip",
                    "matchit",
                    "matchparen",
                    "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
        --readme = {
        --    root = vim.fn.stdpath("state") .. "/lazy/readme",
        --    files = { "README.md", "lua/**/README.md" },
        --    -- only generate markdown helptags for plugins that dont have docs
        --    skip_if_doc_exists = true,
        --},
        --state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
    })
end

return M
