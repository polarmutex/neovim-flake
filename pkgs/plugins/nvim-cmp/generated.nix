# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nvim-cmp = {
    pname = "nvim-cmp";
    version = "538e37ba87284942c1d76ed38dd497e54e65b891";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "538e37ba87284942c1d76ed38dd497e54e65b891";
      fetchSubmodules = false;
      sha256 = "sha256-BtAYRYn6m788zAq/mNnbAzAxp1TGf9QkRE0hSOp9sdc=";
    };
    date = "2023-12-14";
  };
}
