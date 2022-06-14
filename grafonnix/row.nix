{
  nixlib,
  POP,
}: {
  new = {
    title ? "Dashboard Row",
    height ? null,
    collapse ? false,
    repeat ? null,
    showTitle ? null,
    titleSize ? "h6",
  }:
    POP.lib.pop {
      defaults =
        {
          inherit collapse;
          collapsed = collapse;
        }
        // nixlib.lib.optionalAttrs (height != null) {
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

      extenders = {
        addPanels = panels: self: super: {
          panels = super.panels ++ panels;
        };
        addPanel = {
          panel,
          gridPos ? {},
        }: self: super: {
          panels =
            super.panels
            ++ [
              (POP.lib.pop {
                supers = [panel];
                extension = _: _: {
                  inherit gridPos;
                };
              })
            ];
        };
      };
    };
}
