{ system, inputs }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  converter = pkgs.haskellPackages.callPackage (

{ mkDerivation, aeson, aeson-better-errors, async-pool, base
, bytestring, containers, data-fix, directory, filepath, hnix
, hpack, lib, mtl, optparse-applicative, prettyprinter, process
, protolude, regex-tdfa, scientific, stm, text, transformers
, unordered-containers
}:
mkDerivation {
  pname = "grafonnix-converter";
  version = "0.1.0";
  src = ./converter;
  isLibrary = false;
  isExecutable = true;
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson aeson-better-errors async-pool base bytestring containers
    data-fix directory filepath hnix mtl optparse-applicative
    prettyprinter process protolude regex-tdfa scientific stm text
    transformers unordered-containers
  ];
  prePatch = "hpack";
  homepage = "https://github.com/divnix/grafonnix-converter#readme";
  description = "Convert grafana json dashboards to grafonnix expressions";
  license = lib.licenses.mit;
}

) {};
}
