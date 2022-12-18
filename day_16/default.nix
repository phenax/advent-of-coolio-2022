with (import <nixpkgs> { });
mkShell {
  buildInputs = [
    unison-ucm
  ];
}
