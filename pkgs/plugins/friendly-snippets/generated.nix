# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  friendly-snippets = {
    pname = "friendly-snippets";
    version = "43727c2ff84240e55d4069ec3e6158d74cb534b6";
    src = fetchFromGitHub {
      owner = "rafamadriz";
      repo = "friendly-snippets";
      rev = "43727c2ff84240e55d4069ec3e6158d74cb534b6";
      fetchSubmodules = false;
      deepClone = true;
      leaveDotGit = true;
      sha256 = "sha256-oK0QCTiwGJwfzTIGQ0Tm1+F4tuFRfcoZq4PuPnVVAQk=";
    };
    date = "2023-10-01";
  };
}
