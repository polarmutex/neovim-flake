# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  gitsigns-nvim = {
    pname = "gitsigns-nvim";
    version = "5a9a6ac29a7805c4783cda21b80a1e361964b3f2";
    src = fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "5a9a6ac29a7805c4783cda21b80a1e361964b3f2";
      fetchSubmodules = false;
      sha256 = "sha256-9DIfUVcU5aZXPUGueBnUlv2IgUh69bDx4vGnGeNJ+u0=";
    };
    date = "2023-10-17";
  };
}
