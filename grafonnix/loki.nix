{lib}: {
  /*
    *
   * Creates a [Loki target](https://grafana.com/docs/grafana/latest/datasources/loki/)
   *
   * @name loki.target
   *
   * @param expr
   * @param hide (optional) Disable query on graph.
   * @param legendFormat (optional) Defines the legend. Defaults to "".
   */
  target = {
    expr,
    hide ? null,
    legendFormat ? "",
  }:
    lib.kPop
    (lib.optionalAttrs (hide != null) {
      inherit hide;
    })
    // {
      expr = expr;
      legendFormat = legendFormat;
    };
}
