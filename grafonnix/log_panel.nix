{lib}: {
  /*
    *
   * Creates a [log panel](https://grafana.com/docs/grafana/latest/panels/visualizations/logs-panel/).
   * It requires the log panel plugin in grafana, which is built-in.
   *
   * @name logPanel.new
   *
   * @param title (default `""`) The title of the log panel.
   * @param span (optional) Width of the panel
   * @param datasource (optional) Datasource
   * @showLabels (default `false`) Whether to show or hide labels
   * @showTime (default `true`) Whether to show or hide time for each line
   * @wrapLogMessage (default `true`) Whether to wrap log line to the next line
   * @sortOrder (default `"Descending"`) sort log by time (can be "Descending" or "Ascending" )
   *
   * @method addTarget(target) Adds a target object
   * @method addTargets(targets) Adds an array of targets
   */
  new = {
    title ? "",
    datasource ? null,
    time_from ? null,
    time_shift ? null,
    showLabels ? false,
    showTime ? true,
    sortOrder ? "Descending",
    wrapLogMessage ? true,
    span ? 12,
    height ? null,
  }:
    lib.pop {
      extension = self: super:
        lib.optionalAttrs (height != null) {
          height = height;
        }
        // {
          span = span;
          datasource = datasource;
          options = {
            showLabels = showLabels;
            showTime = showTime;
            sortOrder = sortOrder;
            wrapLogMessage = wrapLogMessage;
          };
          targets = [];
          _nextTarget = 0;
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
          addTargets = targets: lib.foldl (p: t: p.addTarget t) self targets;
          timeFrom = time_from;
          timeShift = time_shift;
          title = title;
          type = "logs";
        };
    };
}
