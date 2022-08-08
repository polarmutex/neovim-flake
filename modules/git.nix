{ pkgs, ... }: {

  plugins = with pkgs.neovimPlugins; [
    blamer-nvim
    diffview-nvim
    gitsigns-nvim
    neogit
    plenary-nvim
  ];

  setup.gitsigns = { };

  setup.neogit = {
    kind = "split";
    signs = {
      section = [ "" "" ];
      item = [ "" "" ];
    };

    integrations.diffview = true;
  };

}
