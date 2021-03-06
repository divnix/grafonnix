{lib}: {
  default = {
    builtIn = 1;
    datasource = "-- Grafana --";
    enable = true;
    hide = true;
    iconColor = "rgba(0, 211, 255, 1)";
    name = "Annotations & Alerts";
    type = "dashboard";
  };

  /*
    *
   * @name annotation.datasource
   */

  datasource = {
    name,
    datasource,
    expr ? null,
    enable ? true,
    hide ? false,
    iconColor ? "rgba(255, 96, 96, 1)",
    tags ? [],
    type ? "tags",
    builtIn ? null,
  }:
    lib.kPop
    ({
        datasource = datasource;
        enable = enable;
      }
      // lib.optionalAttrs (expr != null) {
        inherit expr;
      }
      // {
        hide = hide;
        iconColor = iconColor;
        name = name;
        showIn = 0;
        tags = tags;
        type = type;
      }
      // lib.optionalAttrs (builtIn != null) {
        inherit builtIn;
      });
}
