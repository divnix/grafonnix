{lib}: {
  /*
    *
   * Creates a [table panel](https://grafana.com/docs/grafana/latest/panels/visualizations/table-panel/) that can be added in a row.
   * It requires the table panel plugin in grafana, which is built-in.
   *
   * @name table.new
   *
   * @param title The title of the graph panel.
   * @param description (optional) Description of the panel
   * @param span (optional)  Width of the panel
   * @param height (optional)  Height of the panel
   * @param datasource (optional) Datasource
   * @param min_span (optional)  Min span
   * @param styles (optional) Array of styles for the panel
   * @param columns (optional) Array of columns for the panel
   * @param sort (optional) Sorting instruction for the panel
   * @param transform (optional) Allow table manipulation to present data as desired
   * @param transparent (default: "false") Whether to display the panel without a background
   * @param links (optional) Array of links for the panel.
   * @return A json that represents a table panel
   *
   * @method addTarget(target) Adds a target object
   * @method addTargets(targets) Adds an array of targets
   * @method addColumn(field, style) Adds a column
   * @method hideColumn(field) Hides a column
   * @method addLink(link) Adds a link
   * @method addTransformation(transformation) Adds a transformation object
   * @method addTransformations(transformations) Adds an array of transformations
   */
  new = {
    title,
    description ? null,
    span ? null,
    min_span ? null,
    height ? null,
    datasource ? null,
    styles ? [],
    transform ? null,
    transparent ? false,
    columns ? [],
    sort ? null,
    time_from ? null,
    time_shift ? null,
    links ? [],
  }:
    lib.pop {
      visibility = {
        _nextTarget = false;
        addTarget = false;
        addTargets = false;
        addColumn = false;
        hideColumn = false;
        addLink = false;
        addTransformation = false;
        addTransformations = false;
      };
      defaults =
        {
          type = "table";
          title = title;
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
        // {
          datasource = datasource;
          targets = [];
          styles = styles;
          columns = columns;
          timeFrom = time_from;
          timeShift = time_shift;
          links = links;
        }
        // lib.optionalAttrs (sort != null) {
          sort = sort;
        }
        // lib.optionalAttrs (description != null) {
          description = description;
        }
        // lib.optionalAttrs (transform != null) {
          transform = transform;
        }
        // lib.optionalAttrs (transparent != null) {
          transparent = transparent;
        }
        // {
          _nextTarget = 0;
        };
      extension = self: super: {
        addTarget = target:
          lib.extendPop self (self: super: {
            _nextTarget = super._nextTarget + 1;
            targets = let
              letters = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"];
              refId = builtins.elemAt letters super._nextTarget;
              newTarget = lib.kxPop target {
                inherit refId;
              };
            in
              super.targets ++ [newTarget];
          });
        addTargets = targets:
          lib.foldl (p: t: p.addTarget t) self targets;

        addColumn = field: style: let
          style_ = style {pattern = field;};
          column_ = {
            text = field;
            value = field;
          };
        in
          lib.extendPop self (self: super: {
            styles = super.styles ++ [style_];
            columns = super.columns ++ [column_];
          });

        hideColumn = field:
          lib.extendPop self (self: super: {
            styles =
              super.styles
              ++ [
                {
                  alias = field;
                  pattern = field;
                  type = "hidden";
                }
              ];
          });
        addLink = link:
          lib.extendPop self (self: super: {
            links = super.links ++ [link];
          });
        addTransformation = transformation:
          lib.extendPop self (self: super: {
            transformations = super.transformations ++ [transformation];
          });
        addTransformations = transformations:
          lib.foldl (p: t: p.addTransformation t) self transformations;
      };
    };
}
