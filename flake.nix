{
  inputs.yants.url = "github:divnix/yants";
  inputs.nixlib.url = "github:nix-community/nixpkgs.lib";

  outputs = {
    self,
    yants,
    nixlib,
  }: {
    lib = {
      row.new = {
        title ? "Dashboard Row",
        height ? null,
        collapse ? false,
        repeat ? null,
        showTitle ? null,
        titleSize ? "h6",
      }: let
        self = {
          inherit title titleSize collapse repeat;
          type = "row";
          collapsed = collapse;
          panels = [];
          repeatIteration = null;
          repeatRowId = null;
          showTitle =
            if showTitle != null
            then showTitle
            else title != "Dashboard Row";
          addPanels = {panels}: self // {panels = self.panels ++ panels;};
          addPanel = {
            panel,
            gridPos ? {},
          }:
            self
            // {
              panels = self.pannels ++ [(panel // {inherit gridPos;})];
            };
        };
      in
        self;

    };
  };
}
