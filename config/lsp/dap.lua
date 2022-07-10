local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

daptext.setup()
dapui.setup({
    layouts = {
        {
            elements = {
                "console",
            },
            size = 7,
            position = "bottom",
        },
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "watches",
            },
            size = 40,
            position = "left",
        },
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(1)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local map = vim.keymap.set
--nnoremap("<Home>", function()
--    dapui.toggle(1)
--end)
--nnoremap("<End>", function()
--    dapui.toggle(2)
--end)

map("n", "<Leader><Leader>", function()
    dapui.close()
end, {
    desc = "dap: close dap-ui",
    noremap = true,
    silent = true,
})

map("n", "<F5>", function()
    dap.continue()
end, {
    desc = "dap: continue",
    noremap = true,
    silent = true,
})
map("n", "<F10>", function()
    dap.step_over()
end, {
    desc = "dap: step over",
    noremap = true,
    silent = true,
})
map("n", "<F11>", function()
    dap.step_into()
end, {
    desc = "dap: step in",
    noremap = true,
    silent = true,
})
--nnoremap("<Left>", function()
--    dap.step_out()
--end)
map("n", "<Leader>b", function()
    dap.toggle_breakpoint()
end, {
    desc = "dap: toggle breakpoint",
    noremap = true,
    silent = true,
})
map("n", "<Leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, {
    desc = "dap: set breakpoint",
    noremap = true,
    silent = true,
})
--nnoremap("<leader>rc", function()
--    dap.run_to_cursor()
--end)

-- RUST
local dutils = require("dap.utils")
local user_select = function(prompt, options)
    local choices = { prompt }
    for i, line in ipairs(options) do
        if string.len(line) > 0 then
            table.insert(choices, string.format("%d %s", i, line))
        end
    end

    local choice = vim.fn.inputlist(choices)
    if choice < 1 or choice > #options then
        return nil
    end

    return options[choice]
end

local function rust_crate()
    local metadata_json = vim.fn.system("cargo metadata --format-version 1 --no-deps")
    local metadata = vim.fn.json_decode(metadata_json)
    local target_dir = metadata.target_directory

    local results = {}
    for _, package in ipairs(metadata.packages) do
        for _, target in ipairs(package.targets) do
            if vim.tbl_contains(target.kind, "bin") then
                table.insert(results, target_dir .. "/debug/" .. target.name)
            end
        end
    end

    if #results == 1 then
        return results[1]
    end
    return user_select("Select target:", results)
end

local function lldb_init_commands()
    local sysroot = vim.fn.system("rustc --print sysroot"):gsub("\n", "")
    local path = sysroot .. "/lib/rustlib/etc"
    local lookup = string.format([[command script import "%s"/lldb_lookup.py]], path)
    local commands = string.format([[command source "%s"/lldb_commands]], path)
    local result = {
        lookup,
        commands,
    }

    return result
end

dap.adapters.lldb_rust = {
    name = "lldb",
    type = "executable",
    attach = {
        pidProperty = "pid",
        pidSelect = "ask",
    },
    command = "lldb-vscode",
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
    },
    --initCommands = lldb_init_commands(),
}

dap.configurations.rust = {
    {
        name = "Debug Crate",
        type = "lldb_rust",
        request = "launch",
        program = function()
            return rust_crate()
        end,
        args = {},
    },
    {
        -- If you get an "Operation not permitted" error using this, try disabling YAMA:
        --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        name = "Attach",
        type = "lldb_rust",
        request = "attach",
        --pid = dutils.pick_process,
        pid = 159329,
        args = {},
    },
}
