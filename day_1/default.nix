with (import <nixpkgs> { });
let
  fakeGit = writeScriptBin "git" "echo running fake git";

  cbqn_replxx = stdenv.mkDerivation rec {
    pname = "cbqn-replxx";
    version = "0.0.0";

    src = fetchgit {
      url = "https://github.com/dzaima/CBQN.git";
      rev = "dbc7c83f7085d05e87721bedf1ee38931f671a8e";
      hash = "sha256-vfUakbefpCZpJLOkWi8Bp7Fix4lqwKUX7bKt6mSunts=";
      fetchSubmodules = true;
    };

    buildPhase = ''make SHELL=${pkgs.bash}/bin/bash REPLXX=1;'';

    installPhase = ''
      mkdir -p $out/bin;
      make PREFIX=$out SHELL=${pkgs.bash}/bin/bash install;
    '';

    buildInputs = [ libffi clang fakeGit ];
  };
in
mkShell {
  buildInputs = with pkgs; [
    cbqn_replxx
    clang
    libffi
  ];
}
