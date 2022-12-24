with (import <nixpkgs> { });
mkShell {
  buildInputs = [
    scala
    scalafmt
    metals
    sbt
  ];
}
