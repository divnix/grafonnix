{ POP, nixlib }:
{
  /**
   * Creates a [Graphite target](https://grafana.com/docs/grafana/latest/datasources/graphite/)
   *
   * @name graphite.target
   *
   * @param target Graphite Query. Nested queries are possible by adding the query reference (refId).
   * @param targetFull (optional) Expanding the @target. Used in nested queries.
   * @param hide (default `false`) Disable query on graph.
   * @param textEditor (default `false`) Enable raw query mode.
   * @param datasource (optional) Datasource.

   * @return Panel target
   */
  target = {
    target,
    targetFull?null,
    hide?false,
    textEditor?false,
    datasource?null,
  }: POP.lib.kPop {
    target= target;
    hide= hide;
    textEditor= textEditor;
    }
    // nixlib.lib.optionalAttrs ( targetFull != null ) {
      inherit targetFull;
    } // nixlib.lib.optionalAttrs (datasource != null) {
      inherit datasource;
    };
}
