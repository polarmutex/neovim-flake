# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-nio = {
    pname = "nvim-nio";
    version = "v1.8.1";
    src = fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "v1.8.1";
      fetchSubmodules = false;
      sha256 = "sha256-MHCrUisx3blgHWFyA5IHcSwKvC1tK1Pgy/jADBkoXX0=";
    };
  };
}