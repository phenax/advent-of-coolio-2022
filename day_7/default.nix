{ nixpkgs ? import <nixpkgs> { }, haskellPackages ? nixpkgs.haskellPackages, compiler ? "default", doBenchmark ? false, nodePackages ? nixpkgs.nodePackages }:

let
  inherit (nixpkgs) pkgs;
  systemPackages = [
    haskellPackages.haskell-language-server
    haskellPackages.cabal-install
    nodePackages.nodemon
    pkgs.hpack
  ];

  commonHsPackages = with haskellPackages; [ ];
in
with haskellPackages; mkDerivation {
  pname = "haskmelater";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = commonHsPackages;
  executableHaskellDepends = commonHsPackages;
  executableSystemDepends = systemPackages;
  testHaskellDepends = commonHsPackages ++ [ ];
  license = "MIT";
  hydraPlatforms = stdenv.lib.platforms.none;
}
