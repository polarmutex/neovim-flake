local overseer = require("overseer")

local tmpl = {
    priority = 60,
    params = {
        --cmd = { type = "string" },
        args = { type = "list", delimiter = " " },
    },
    builder = function(params)
        local cmd = {}
        if params.args then
            cmd = vim.list_extend(cmd, params.args)
        end

        return {
            cmd = cmd,
            --args = params.args,
        }
    end,
}

---@param opts overseer.SearchParams
---@return nil|string
local function get_conan_file(opts)
    return vim.fs.find("conanfile.py", { upward = true, type = "file", path = opts.dir })[1]
end

return {
    condition = {
        filetype = { "c", "cpp" },
        callback = function(opts)
            if vim.fn.executable("conan") == 0 then
                return false, 'Command "conan" not found'
            end
            if not get_conan_file(opts) then
                return false, "No Cargo.toml file found"
            end
            return true
        end,
    },
    generator = function(_, cb)
        local ret = {}
        local commands = {
            {
                name = "conan install",
                cmd = "conan",
                args = {
                    "conan",
                    "install",
                    ".",
                    "-s",
                    "build_type=Release",
                    "-pr:h",
                    "default",
                    "-pr:b",
                    "default",
                },
            },
            {
                name = "cmake build",
                cmd = "cmake",
                args = {
                    "cmake",
                    "-B",
                    "build",
                    "-S",
                    ".",
                    "-DCMAKE_TOOLCHAIN_FILE=Release/generators/conan_toolchain.cmake",
                    "-DCMAKE_BUILD_TYPE=Release",
                },
            },
            {
                name = "make",
                cmd = "make",
                args = {
                    "make",
                    "-C",
                    "build",
                },
            },
        }
        for _, command in ipairs(commands) do
            table.insert(
                ret,
                overseer.wrap_template(tmpl, {
                    name = command.name,
                    tags = command.tags,
                    priority = 60,
                }, { args = command.args, save = command.save })
            )
        end
        cb(ret)
    end,
}
