
function start_jdtls()
  local settings = {
    java = {
      signatureHelp = { enabled = true },
      referenceCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      autobuild = { enabled = true },
      trace = { server = "verbose" },
      -- contentProvider = { preferred = 'fernflower' };
      -- completion = {
      --   favoriteStaticMembers = {
      --     "org.hamcrest.MatcherAssert.assertThat",
      --     "org.hamcrest.Matchers.*",
      --     "org.hamcrest.CoreMatchers.*",
      --     "org.junit.jupiter.api.Assertions.*",
      --     "java.util.Objects.requireNonNull",
      --     "java.util.Objects.requireNonNullElse",
      --     "org.mockito.Mockito.*"
      --   }
      -- },
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        }
      },
    },
  }
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local root_dir = root_pattern('.git', 'gradlew', 'mvnw', 'pom.xml')(bufname)
  local workspace_dir = "/tmp/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
  local bundles = {
    "@java.debug.plugin@"
  };
  vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jlle/tmp/vscode-java-test/server/*.jar"), "\n"))

  require('jdtls').start_or_attach({
      cmd = {'jdt-ls', '-data', workspace_dir},
      on_attach = jdt_on_attach,
      root_dir = root_dir,
      capabilities = capabilities,
      settings = settings,
      init_options = {
        bundles = bundles,
        extendedCapabilities = require('jdtls').extendedClientCapabilities,
      },
    })
end

vim.api.nvim_exec([[
augroup LspCustom
  autocmd!
  autocmd FileType java lua start_jdtls()
augroup END
]], true)
