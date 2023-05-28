{
  pkgs,
  lib,
}:
#let
#inherit (python.passthru) pythonOlder;
#in
pkgs.python3Packages.buildPythonPackage rec {
  pname = "mdformat-tables";
  version = "0.4.1";
  format = "flit";
  #disabled = pythonOlder "3.6";
  src = pkgs.fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-tables";
    rev = "v${version}";
    # for tests
    #fetchSubmodules = true;
    hash = "sha256-Q61GmaRxjxJh9GjyR8QCZOH0njFUtAWihZ9lFQJ2nQQ=";
  };
  postPatch = ''
    #substituteInPlace pyproject.toml \
    #  --replace "'pytest-cov', 'pytest-flake8', 'pytest-isort', 'coverage[toml]'" "" \
    #  --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';
  nativeBuildInputs = [pkgs.python311Packages.flit-core];
  propagatedBuildInputs = [pkgs.python310Packages.mdformat];
  #nativeCheckInputs = [pytestCheckHook];
  meta = with lib; {
    description = "An mdformat plugin for rendering tables ";
    homepage = "https://github.com/executablebooks/mdformat-tables";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
  };
}
