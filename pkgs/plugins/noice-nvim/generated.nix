# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  noice-nvim = {
    pname = "noice-nvim";
    version = "v1.16.0";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "noice.nvim";
      rev = "v1.16.0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-bI0187Uj3rWYU8GYeoiPCXZ6ct4KWmIXKb4mhUcTeAo=";
    };
  };
}
