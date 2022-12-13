with (import <nixpkgs> { });
mkShell {
  buildInputs = [
    jq
  ];
}
