# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  sqlite-lua = {
    pname = "sqlite-lua";
    version = "v1.2.2";
    src = fetchFromGitHub {
      owner = "kkharji";
      repo = "sqlite.lua";
      rev = "v1.2.2";
      fetchSubmodules = false;
      sha256 = "sha256-NUjZkFawhUD0oI3pDh/XmVwtcYyPqa+TtVbl3k13cTI=";
    };
  };
}
