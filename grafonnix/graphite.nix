{lib}: {
  /*
    *
   * Creates a [Graphite target](https://com/docs/grafana/latest/datasources/graphite/)
   *
   * @name target
   *
   * @param target Graphite  Nested queries are possible by adding the query reference (refId).
   * @param targetFull (optional) Expanding the @ Used in nested queries.
   * @param hide (default `false`) Disable query on
   * @param textEditor (default `false`) Enable raw query
   * @param datasource (optional)
   
   * @return Panel target
   */
  target = {
    target,
    targetFull ? null,
    hide ? false,
    textEditor ? false,
    datasource ? null,
  }:
    lib.kPop {
      target = target;
      hide = hide;
      textEditor = textEditor;
    }
    // lib.optionalAttrs (targetFull != null) {
      inherit targetFull;
    }
    // lib.optionalAttrs (datasource != null) {
      inherit datasource;
    };
}
