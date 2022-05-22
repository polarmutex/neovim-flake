{ pkgs
, dsl
, ...
}:
with dsl;
{

  use.lspconfig.beancount.setup = callWith {
    cmd = [ "${pkgs.beancount-language-server}/bin/beancount-language-server" ];
    capabilities = rawLua
      "require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())";
    on_attach = rawLua "on_attach";
    init_options = {
      journal_file = "/home/polar/repos/personal/beancount/journal.beancount";
    };
  };

}
