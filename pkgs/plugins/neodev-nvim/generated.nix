# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  neodev-nvim = {
    pname = "neodev-nvim";
    version = "b2881eeb395d2b268de5fe9b5e201a8f1816beb8";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "neodev.nvim";
      rev = "b2881eeb395d2b268de5fe9b5e201a8f1816beb8";
      fetchSubmodules = false;
      sha256 = "sha256-CRPbXQvxX4dfrbs1rDA64XwGKGKBlYJ8M19fttmalgs=";
    };
    date = "2023-11-15";
  };
}
