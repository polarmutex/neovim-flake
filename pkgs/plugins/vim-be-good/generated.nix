# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  vim-be-good = {
    pname = "vim-be-good";
    version = "c290810728a4f75e334b07dc0f3a4cdea908d351";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "vim-be-good";
      rev = "c290810728a4f75e334b07dc0f3a4cdea908d351";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-ybgPQl0PPZaTpmiILWd5pa8alreETS/CrUUEmqaCNMA=";
    };
    date = "2022-11-08";
  };
}
