 -- Load the colorscheme
local default_colors = require("kanagawa.colors").setup()
local my_colors = {};
local overrides = {
diffAdded = { fg = default_colors.springGreen };
};
require'kanagawa'.setup({ overrides = overrides, colors = my_colors })
vim.cmd[[colorscheme kanagawa]]
