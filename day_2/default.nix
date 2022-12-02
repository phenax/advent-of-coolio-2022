with (import <nixpkgs> { });
mkShell {
  buildInputs = with pkgs; [
    swiProlog
    nodePackages.nodemon
  ];
}
