# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  plenary-nvim = {
    pname = "plenary-nvim";
    version = "9ce85b0f7dcfe5358c0be937ad23e456907d410b";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "9ce85b0f7dcfe5358c0be937ad23e456907d410b";
      fetchSubmodules = false;
      deepClone = true;
      leaveDotGit = true;
      sha256 = "sha256-nWzIgV1iIRUp+xXkhfcz2OnaRkACNxcu4LV+T36x04c=";
    };
    date = "2023-09-12";
  };
}
