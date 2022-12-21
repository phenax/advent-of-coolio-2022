with (import <nixpkgs> { });
mkShell {
  buildInputs = [ dotnet-sdk ];
}
