with (import <nixpkgs> { });
mkShell {
  buildInputs = [
    ocaml
    ocamlPackages.merlin-lib
    ocamlPackages.ocaml-lsp
    ocamlPackages.merlin
    nodePackages.ocaml-language-server
  ];
}
