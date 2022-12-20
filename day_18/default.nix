with (import <nixpkgs> { });
mkShell {
  buildInputs = [
    nim
  ];
}
