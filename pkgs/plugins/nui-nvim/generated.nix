# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nui-nvim = {
    pname = "nui-nvim";
    version = "0.2.0";
    src = fetchFromGitHub {
      owner = "MunifTanjim";
      repo = "nui.nvim";
      rev = "0.2.0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-FS/PudH8XKD1hZnp1meXmxog23uHd0kHAZCFfkpAOrE=";
    };
  };
}
