# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  flash-nvim = {
    pname = "flash-nvim";
    version = "v1.18.2";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "v1.18.2";
      fetchSubmodules = false;
      sha256 = "sha256-j917u46PaOG6RmsKKoUQHuBMfXfGDD/uOBzDGhKlwTE=";
    };
  };
}
