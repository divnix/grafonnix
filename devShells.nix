{ system, inputs }:
let
  inherit (inputs) nixpkgs;

  pkgs = nixpkgs.legacyPackages.${system};
in
{
  converter =
    let
      compilerVersion = "ghc8107";
      compiler = pkgs.haskell.packages."${compilerVersion}";
    in
      compiler.developPackage {
        root = ./converter;
        source-overrides = {
          # named = builtins.fetchTarball
          #  "https://github.com/monadfix/named/archive/e684a00.tar.gz";
        };
        modifier = drv:
          pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
            [ cabal-install
              ghcid
              pkgs.zlib
              pkgs.pkg-config
              pkgs.libsodium
              cabal2nix
            ]);
      };

}
