# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  telescope-nvim = {
    pname = "telescope-nvim";
    version = "0.1.6";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "0.1.6";
      fetchSubmodules = false;
      sha256 = "sha256-NmB9VDPmnZifUDQl3APWb81isbRTK6+k5onT6bthoqw=";
    };
  };
}
