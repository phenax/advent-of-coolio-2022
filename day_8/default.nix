with (import <nixpkgs> { });
mkShell {
  buildInputs = with pkgs; [
    gleam
    erlang
    rebar3
  ];
}

