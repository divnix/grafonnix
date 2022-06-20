{lib}: {
  /*
    *
   * Creates a pie chart panel.
   * It requires the [pie chart panel plugin in grafana](https://grafana.com/grafana/plugins/grafana-piechart-panel),
   * which needs to be explicitly installed.
   *
   * @name pieChartPanel.new
   *
   * @param title The title of the pie chart panel.
   * @param description (default `""`) Description of the panel
   * @param span (optional) Width of the panel
   * @param min_span (optional) Min span
   * @param datasource (optional) Datasource
   * @param aliasColors (optional) Define color mappings
   * @param pieType (default `"pie"`) Type of pie chart (one of pie or donut)
   * @param showLegend (default `true`) Show legend
   * @param showLegendPercentage (default `true`) Show percentage values in the legend
   * @param legendType (default `"Right side"`) Type of legend (one of "Right side", "Under graph" or "On graph")
   * @param valueName (default `"current") Type of tooltip value
   * @param repeat (optional) Variable used to repeat the pie chart
   * @param repeatDirection (optional) Which direction to repeat the panel, "h" for horizontal and "v" for vertical
   * @param maxPerRow (optional) Number of panels to display when repeated. Used in combination with repeat.
   * @return A json that represents a pie chart panel
   *
   * @method addTarget(target) Adds a target object.
   */
  new = {
    title,
    description ? "",
    span ? null,
    min_span ? null,
    datasource ? null,
    height ? null,
    aliasColors ? {},
    pieType ? "pie",
    valueName ? "current",
    showLegend ? true,
    showLegendPercentage ? true,
    legendType ? "Right side",
    repeat ? null,
    repeatDirection ? null,
    maxPerRow ? null,
  }:
    lib.pop {
      extension = self: super:
        {
          type = "grafana-piechart-panel";
        }
        // lib.optionalAttrs (description != null) {
          description = description;
        }
        // {
          pieType = pieType;
          title = title;
          aliasColors = aliasColors;
        }
        // lib.optionalAttrs (span != null) {
          span = span;
        }
        // lib.optionalAttrs (min_span != null) {
          minSpan = min_span;
        }
        // lib.optionalAttrs (height != null) {
          height = height;
        }
        // lib.optionalAttrs (repeat != null) {
          repeat = repeat;
        }
        // lib.optionalAttrs (repeatDirection != null) {
          repeatDirection = repeatDirection;
        }
        // lib.optionalAttrs (maxPerRow != null) {
          maxPerRow = maxPerRow;
        }
        // {
          valueName = valueName;
          datasource = datasource;
          legend = {
            show = showLegend;
            values = true;
            percentage = showLegendPercentage;
          };
          legendType = legendType;
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
        };
    };
}
