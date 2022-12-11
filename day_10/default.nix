with (import <nixpkgs> { });
mkShell {
  buildInputs = [ elixir ];
}
