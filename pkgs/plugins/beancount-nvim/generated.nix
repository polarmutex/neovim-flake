# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  beancount-nvim = {
    pname = "beancount-nvim";
    version = "869564aba3087ee5df8f282aa37555e314aa2152";
    src = fetchFromGitHub {
      owner = "polarmutex";
      repo = "beancount.nvim";
      rev = "869564aba3087ee5df8f282aa37555e314aa2152";
      fetchSubmodules = false;
      sha256 = "sha256-LuACGVB3kiaiJqoGtvFy6kbPNtqoGliKLDeR+Z7Wzbw=";
    };
    date = "2024-02-12";
  };
}
