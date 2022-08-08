{ pkgs, lib, dsl, ... }: with dsl;
let
  inherit (lib) getExe;
  capabilities = rawLua "capabilities";
in
{

  imports = [
    ./rust.nix
  ];

  plugins = with pkgs.neovimPlugins; [
    # completion framework
    cmp-nvim-lsp
    nvim-cmp
    cmp-buffer
    # lsp things
    #lsp_signature-nvim
    lspkind-nvim
    nvim-lspconfig
    # utility functions for lsp
    plenary-nvim
    # popout for documentation
    popup-nvim
    # snippets lists
    #friendly-snippets
    # for showing lsp progress
    fidget-nvim
    trouble-nvim
  ];

  setup.fidget = { };

  use.trouble.setup = callWith { };


  #setup.lsp_signature = {
  #  bind = true;
  #  hint_enable = false;
  #  hi_parameter = "Visual";
  #  handler_opts.border = "single";
  #};

  setup.cmp = {
    mapping = {
      "['<C-n>']" = rawLua "cmp.mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Insert })";
      "['<Down>']" = rawLua "cmp.mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Select })";
      "['<Tab>']" = rawLua "cmp.mapping.select_next_item({ behavior = require('cmp').SelectBehavior.Select })";

      "['<C-p>']" = rawLua "cmp.mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Insert })";
      "['<Up>']" = rawLua "cmp.mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Select })";
      "['<S-Tab>']" = rawLua "cmp.mapping.select_prev_item({ behavior = require('cmp').SelectBehavior.Select })";

      "['<C-d>']" = rawLua "cmp.mapping.scroll_docs(-4)";
      "['<C-f>']" = rawLua "cmp.mapping.scroll_docs(4)";
      "['<C-Space>']" = rawLua "cmp.mapping.complete()";
      "['<C-e>']" = rawLua "cmp.mapping.close()";
      "['<CR>']" = rawLua "cmp.mapping.confirm({ behavior = require('cmp').ConfirmBehavior.Replace, select = true, })";
    };
    sources = [
      { name = "nvim_lsp"; }
      { name = "vsnip"; }
      { name = "crates"; }
      { name = "path"; }
      { name = "buffer"; keyword_length = 5; }
    ];
    formatting = {
      # Youtube: How to set up nice formatting for your sources.
      #format = rawLua "lspkind.cmp_format({
      #      with_text = true,
      #      menu = {
      #          buffer = '[buf]',
      #          nvim_lsp = '[LSP]',
      #          nvim_lua = '[api]',
      #          path = '[path]',
      #          --luasnip = '[snip]',
      #          gh_issues = '[issues]',
      #      },
      #  })";
    };
    snippet.expand = rawLua ''function(args) vim.fn["vsnip#anonymous"](args.body) end '';
  };

  function.show_documentation = ''
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim','help' }, filetype) then
        vim.cmd('h '..vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man '..vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
  '';

  lua = ''
    local augroup_format = vim.api.nvim_create_augroup("my_lsp_format", { clear = true })
    local autocmd_format = function(async, filter)
      vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format { async = async, filter = filter }
        end,
      })
    end

    local filetype_attach = setmetatable({
      beancount = function()
        autocmd_format(false)
      end,

      nix = function()
        autocmd_format(false)
      end,

      typescript = function()
        autocmd_format(false, function(clients)
          return vim.tbl_filter(function(client)
            return client.name ~= "tsserver"
          end, clients)
        end)
      end,
    }, {
      __index = function()
        return function() end
      end,
    })
    local custom_attach = function(client)
      local filetype = vim.api.nvim_buf_get_option(0, "filetype")
       -- Attach any filetype specific options to the client
      filetype_attach[filetype](client)
    end
  '';

  use.lspconfig.beancount.setup = callWith {
    #cmd = [ "${pkgs.beancount-language-server}/bin/beancount-language-server" ];
    cmd = [ "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server" ];
    init_options = {
      journal_file = "/home/polar/repos/personal/beancount/main.beancount";
    };
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

  use.lspconfig.clangd.setup = callWith {
    cmd = [ "${pkgs.clang-tools}/bin/clangd" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

  use.lspconfig.gopls.setup = callWith {
    cmd = [ "${pkgs.gopls}/bin/gopls" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

  use.lspconfig.jsonls.setup = callWith {
    cmd = [ (getExe pkgs.nodePackages.vscode-json-languageserver) "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

  use.lspconfig.pyright.setup = callWith {
    cmd = [ "${pkgs.pyright}/bin/pyright-langserver" "--stdio" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

  use.lspconfig.rnix.setup = callWith {
    cmd = [ (getExe pkgs.rnix-lsp) ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "custom_attach";
  };

}
