# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  lualine-nvim = {
    pname = "lualine-nvim";
    version = "8b56462bfb746760465264de41b4907310f113ec";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "8b56462bfb746760465264de41b4907310f113ec";
      fetchSubmodules = false;
      sha256 = "sha256-G4npmdS7vue68h5QN8vWx3Oh5FHdvmzFHGxqMIRC+Mk=";
    };
    date = "2024-03-04";
  };
}
