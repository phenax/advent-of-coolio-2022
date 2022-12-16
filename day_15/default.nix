with (import <nixpkgs> { });

mkShell {
  buildInputs = [
    koka
  ];
}
