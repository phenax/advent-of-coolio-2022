with import <nixpkgs> { };
let
  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "80627b282705101e7b38e19ca6e8df105031b072"; # 3rd December 2022
    sha256 = "sha256-UGWJHQShiwLCr4/DysMVFrYdYYHcOqAOVsWNUu+l6YU=";
  };

  moz = import "${src.out}/rust-overlay.nix" pkgs pkgs;
  rust = moz.latest.rustChannels.stable.rust.override {
    extensions = [ "rust-src" ];
  };
in
mkShell rec {
  buildInputs = [
    # Build tools
    rust
    nodePackages.nodemon
    nodejs-18_x

    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-language-server

    # Lib deps
    pkg-config
    libclang
  ];
  nativeBuildInputs = [ clang ];

  # RUST_SRC_PATH = rust.packages.stable.rustPlatform.rustLibSrc;
  # RUST_BACKTRACE = 1;
  LIBCLANG_PATH = "${libclang.lib}/lib";
  LD_LIBRARY_PATH = lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);
}
