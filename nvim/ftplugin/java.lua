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

local config = {
    cmd = {
        "jdtls",
        "-configuration",
        get_jdtls_config_dir(),
        "-data",
        get_jdtls_workspace_dir(),
        get_jdtls_jvm_args(),
    },
    filetypes = { "java" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", "build.xml", "pom.xml" }, { upward = true })[1]),
    single_file_support = true,
    capabilities = require("polarmutex.lsp").make_client_capabilities(),
    init_options = {
        workspace = get_jdtls_workspace_dir(),
        jvm_args = {},
        os_config = nil,
    },
    handlers = {
        -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
        -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
        -- ["textDocument/codeAction"] = on_textdocument_codeaction,
        -- ["textDocument/rename"] = on_textdocument_rename,
        -- ["workspace/applyEdit"] = on_workspace_applyedit,
        -- ["language/status"] = vim.schedule_wrap(on_language_status),
    },
}

print("starting java")

vim.lsp.start(config)
