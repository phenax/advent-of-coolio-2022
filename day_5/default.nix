with (import <nixpkgs> { });
mkShell {
  buildInputs = with pkgs; [
    crystal
    nodePackages.nodemon
  ];
}

