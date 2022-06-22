{
  system ? builtins.currentSystem,
  inputs ? (import ./.).inputs,
}: let
  inherit (inputs) nixlib grafonnix grafonnet nixpkgs POP;
  lib =
    nixlib.lib
    // grafonnix.lib
    // POP.lib
    // {
      loadTestFile = f:
        builtins.fromJSON (lib.fileContents "${grafonnet}/tests/${f}");
      loadTestOutput = name:
        lib.loadTestFile "${name}/test_compiled.json";
    };
  pkgs = nixpkgs.legacyPackages.${system};

  tests =
    import ./alert.nix {inherit lib;}
    // import ./alertlist.nix {inherit lib;}
    // import ./annotation.nix {inherit lib;}
    // import ./dashboard {inherit lib;};

  runTests = lib.runTests tests;
in {
  libTests =
    pkgs.runCommandNoCC "grafonnix-lib-tests"
    {
      buildInputs = [
        (
          if runTests == []
          then null
          else
            throw (
              "Failed tests:\n"
              + nixlib.lib.concatStringsSep
              "\n-------------------\n"
              (
                map
                (lib.generators.toPretty {})
                #builtins.toJSON
                runTests
              )
            )
        )
      ];
    } ''
      touch $out
    '';
}
