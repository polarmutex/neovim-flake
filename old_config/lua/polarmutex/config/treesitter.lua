require("nvim-treesitter.configs").setup({
    highlight = { enable = true, disable = {}, custom_captures = {} },
    incremental_selection = {
        enable = true,
        disable = {},
        keymaps = { -- mappings for incremental selection (visual mappings)
            init_selection = "gnn", -- maps in normal mode to init the node/scope selection
            node_incremental = "grn", -- increment to the upper named parent
            scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
            node_decremental = "grm", -- decrement to the previous node
        },
    },
    indent = { enable = false },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = true },
        smart_rename = {
            enable = false,
            keymaps = {
                smart_rename = "grr", -- mapping to rename reference under cursor
            },
        },
        navigation = {
            enable = false,
            keymaps = {
                goto_definition = "gnd", -- mapping to go to definition of symbol under cursor
                list_definitions = "gnD", -- mapping to list all definitions in current file
            },
        },
    },
    textobjects = { -- syntax-aware textobjects
        enable = true,
        disable = {},
        keymaps = {
            -- ["iL"] = { -- you can define your own textobjects directly here
            --  python = "(function_definition) @function",
            --  cpp = "(function_definition) @function",
            --  c = "(function_definition) @function",
            --  java = "(method_declaration) @function"
            -- },
            -- or you use the queries from supported languages with textobjects.scm
            -- ["af"] = "@function.outer",
            -- ["if"] = "@function.inner",
            -- ["aC"] = "@class.outer",
            -- ["iC"] = "@class.inner",
            -- ["ac"] = "@conditional.outer",
            -- ["ic"] = "@conditional.inner",
            -- ["ae"] = "@block.outer",
            -- ["ie"] = "@block.inner",
            -- ["al"] = "@loop.outer",
            -- ["il"] = "@loop.inner",
            -- ["is"] = "@statement.inner",
            -- ["as"] = "@statement.outer",
            -- ["ad"] = "@comment.outer",
            -- ["am"] = "@call.outer",
            -- ["im"] = "@call.inner"
        },
    },
    playground = { enable = true },
    --ensure_installed = {
    --    "python", "beancount", "lua", "c", "cpp", "typescript", "tsx", "svelte",
    --},
})
