{pkgs, ...}: {
  plugins = with pkgs.neovimPlugins; [
    kanagawa-nvim
    lualine-nvim
    nvim-colorizer
    #nvim-web-devicons
    #tabline-nvim
  ];

  lua = ''
    -- load the colorscheme
    local default_colors = require("kanagawa.colors").setup()
          local my_colors = {};
          local overrides = {
            diffAdded = { fg = default_colors.springGreen };
          };
          require'kanagawa'.setup({ overrides = overrides, colors = my_colors })
          vim.cmd[[colorscheme kanagawa]]
  '';

  #setup.tabline.show_index = false;

  setup.lualine = {
    options = {
      component_separators = {
        left = "";
        right = "";
      };
      section_separators = {
        left = "";
        right = "";
      };
      globalstatus = true;
    };
    sections = {
      lualine_a = ["mode"];
      lualine_b = ["branch" "diff" "diagnostics"];
      lualine_c = ["filename"];
      lualine_x = ["encoding" "fileformat" "filetype"];
      lualine_z = ["location"];
    };
    tabline = {};
    extensions = {};
  };
}
