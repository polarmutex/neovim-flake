local os_sep = require("plenary.path").path.sep

local function get_cache_dir()
    return vim.fn.stdpath("cache")
end

local function get_jdtls_cache_dir()
    return get_cache_dir() .. os_sep .. "jdtls"
end

local function get_jdtls_config_dir()
    return get_jdtls_cache_dir() .. os_sep .. "config"
end

local function get_jdtls_workspace_dir()
    return get_jdtls_cache_dir() .. os_sep .. "workspace"
end

local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((os.getenv("JDTLS_JVM_ARGS") or ""), "%S+") do
        local arg = string.format("--jvm-arg=%s", a)
        table.insert(args, arg)
    end
    return unpack(args)
end

local bundles = {
    vim.fn.glob("@java-test@/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1),
}

vim.list_extend(
    bundles,
    vim.split(vim.fn.glob("@java-test@/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar"), "\n")
)

local config = {
    cmd = {
        "jdtls",
        "-configuration",
        get_jdtls_config_dir(),
        "-data",
        get_jdtls_workspace_dir(),
        get_jdtls_jvm_args(),
    },
    init_options = {
        bundles = bundles,
    },
}
print(vim.inspect(bundles))
require("jdtls").start_or_attach(config)
