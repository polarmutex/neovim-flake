# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  neogit = {
    pname = "neogit";
    version = "5b162854e775dd6a1e98073a7b8b837a7e911f8b";
    src = fetchFromGitHub {
      owner = "NeogitOrg";
      repo = "neogit";
      rev = "5b162854e775dd6a1e98073a7b8b837a7e911f8b";
      fetchSubmodules = false;
      sha256 = "sha256-fDn5MQP9v5a4csZUpX7vOy/DgWt1ecWxOgFOEwsSN9U=";
    };
    date = "2024-04-19";
  };
}
