# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  harpoon = {
    pname = "harpoon";
    version = "21f4c47c6803d64ddb934a5b314dcb1b8e7365dc";
    src = fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "21f4c47c6803d64ddb934a5b314dcb1b8e7365dc";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = true;
      sha256 = "sha256-zPIktiBy0sf7Q2kax3pz+3GA3OQa5mFvh6gxpoJX/qY=";
    };
    date = "2023-05-28";
  };
}
