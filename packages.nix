{ system, inputs }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  converter = import ./converter { inherit pkgs; };
}
