{ nixpkgs ? import <nixpkgs> { }, haskellPackages ? nixpkgs.haskellPackages, compiler ? "default", doBenchmark ? false }:

let
  inherit (nixpkgs) pkgs;
  systemPackages = [
    haskellPackages.haskell-language-server
    haskellPackages.cabal-install
  ];

  commonHsPackages = with haskellPackages; [ ];
in
with haskellPackages; mkDerivation {
  pname = "aocday14";
  version = "0.0.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = commonHsPackages;
  executableHaskellDepends = commonHsPackages;
  executableSystemDepends = systemPackages;
  testHaskellDepends = commonHsPackages ++ [ hspec ];
  license = "MIT";
  hydraPlatforms = stdenv.lib.platforms.none;
}
