# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-lint = {
    pname = "nvim-lint";
    version = "b64dbbbada61b7a4eee8e9449314dd07d04b9a45";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-lint";
      rev = "b64dbbbada61b7a4eee8e9449314dd07d04b9a45";
      fetchSubmodules = false;
      sha256 = "sha256-WYw1ZVyOwYn6zxgtAxDzZ3zU96tnb4ELvRVDLnaiYQM=";
    };
    date = "2023-12-05";
  };
}
