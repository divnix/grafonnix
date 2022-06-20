{lib}: {
  /*
    *
   * Create a [bar gauge panel](https://grafana.com/docs/grafana/latest/panels/visualizations/bar-gauge-panel/),
   *
   * @name barGaugePanel.new
   *
   * @param title Panel title.
   * @param description (optional) Panel description.
   * @param datasource (optional) Panel datasource.
   * @param unit (optional) The unit of the data.
   * @param thresholds (optional) An array of threashold values.
   *
   * @method addTarget(target) Adds a target object.
   * @method addTargets(targets) Adds an array of targets.
   */
  new = {
    title,
    description ? null,
    datasource ? null,
    unit ? null,
    thresholds ? [],
  }:
    lib.pop {
      defaults =
        {
          type = "bargauge";
          title = title;
        }
        // lib.optionalAttrs (description != null) {
          inherit description;
        }
        // {
          datasource = datasource;
          targets = [
          ];
          fieldConfig = {
            defaults = {
              unit = unit;
              thresholds = {
                mode = "absolute";
                steps = thresholds;
              };
            };
          };
          _nextTarget = 0;
        };
      extension = self: super: {
        addTarget = target:
          self (self: super: {
            _nextTarget = super._nextTarget + 1;
            targets = let
              letters = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"];
              refId = builtins.elemAt letters super._nextTarget;
              newTarget = target {
                inherit refId;
              };
            in
              super.targets ++ [newTarget];
          });

        addTargets = targets:
          lib.foldl (p: t: p.addTarget t) self targets;
      };

      specialNames = [
        "_nextTarget"
        "addTarget"
        "addTargets"
      ];
    };
}
