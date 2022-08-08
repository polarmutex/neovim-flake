{ pkgs, ... }: {

  plugins = with pkgs.neovimPlugins; [
    diffview-nvim
    gitsigns-nvim
    neogit
    plenary-nvim
  ];

  setup.gitsigns = { };

  setup.neogit = {
    signs = {
      section = [ "" "" ];
      item = [ "" "" ];
    };

    integrations.diffview = true;
  };

}
