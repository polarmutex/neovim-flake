# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  neogit = {
    pname = "neogit";
    version = "38dd297a905ec6869f4c20ea9184a3e514316e3b";
    src = fetchFromGitHub {
      owner = "NeogitOrg";
      repo = "neogit";
      rev = "38dd297a905ec6869f4c20ea9184a3e514316e3b";
      fetchSubmodules = false;
      sha256 = "sha256-TPsOHWvBj0D/vJQENcmYf2HvA3tZ+C1Xo7klqZsh90k=";
    };
    date = "2024-01-16";
  };
}
