# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  lualine-nvim = {
    pname = "lualine-nvim";
    version = "0a5a66803c7407767b799067986b4dc3036e1983";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "0a5a66803c7407767b799067986b4dc3036e1983";
      fetchSubmodules = false;
      sha256 = "sha256-WcH2dWdRDgMkwBQhcgT+Z/ArMdm+VbRhmQftx4t2kNI=";
    };
    date = "2024-04-05";
  };
}
