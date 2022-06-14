{
  inputs.yants.url = "github:divnix/yants";
  inputs.nixlib.url = "github:nix-community/nixpkgs.lib";
  inputs.POP.url = "github:divnix/POP/extenders";

  # Development Dependencies
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

  outputs = {
    self,
    yants,
    nixlib,
    POP,
    nixpkgs,
  }: rec {
    lib = {
      row = import ./grafonnix/row.nix {inherit nixlib POP;};
      heatmap_panel = import ./grafonnix/heatmap_panel.nix {inherit nixlib POP;};
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.alejandra;
  };
}
