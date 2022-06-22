{lib}: {
  new = {
    title ? "Dashboard Row",
    height ? null,
    collapse ? false,
    repeat ? null,
    showTitle ? null,
    titleSize ? "h6",
  }:
    lib.pop {
      visibility = {
        addPanels = false;
        addPanel = false;
      };

      defaults =
        {
          inherit collapse;
          collapsed = collapse;
        }
        // lib.optionalAttrs (height != null) {
          inherit height;
        }
        // {
          # List of pops for each panel
          panels = [];
          inherit repeat;
          repeatIteration = null;
          repeatRowId = null;
          showTitle =
            if showTitle != null
            then showTitle
            else title != "Dashboard Row";
          inherit title;
          type = "row";
          inherit titleSize;
        };

      extension = self: super: {
        addPanels = panels:
          lib.extendPop self (self: super: {
            panels = super.panels ++ panels;
          });
        addPanel = {
          panel,
          gridPos ? {},
        }:
          lib.extendPop self (self: super: {
            panels =
              super.panels
              ++ [(lib.kxPop panel {inherit gridPos;})];
          });
      };
    };
}
