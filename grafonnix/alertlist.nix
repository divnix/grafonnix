{lib}: {
  /*
    *
   * Creates an [Alert list panel](https://grafana.com/docs/grafana/latest/panels/visualizations/alert-list-panel/)
   *
   * @name alertlist.new
   *
   * @param title (default `""`)
   * @param span (optional)
   * @param show (default `"current"`) Whether the panel should display the current alert state or recent alert state changes.
   * @param limit (default `10`) Sets the maximum number of alerts to list.
   * @param sortOrder (default `"1"`) "1": alerting, "2": no_data, "3": pending, "4": ok, "5": paused
   * @param stateFilter (optional)
   * @param onlyAlertsOnDashboard (optional) Shows alerts only from the dashboard the alert list is in
   * @param transparent (optional) Whether to display the panel without a background
   * @param description (optional)
   * @param datasource (optional)
   */
  new = {
    title ? "",
    span ? null,
    show ? "current",
    limit ? 10,
    sortOrder ? 1,
    stateFilter ? [],
    onlyAlertsOnDashboard ? true,
    transparent ? null,
    description ? null,
    datasource ? null,
  }:
    lib.kPop (lib.optionalAttrs (transparent != null) {
      inherit transparent;
    })
    // {
      title = title;
    }
    // lib.optionalAttrs (span != null) {
      inherit span;
    }
    // {
      type = "alertlist";
      show = show;
      limit = limit;
      sortOrder = sortOrder;
    }
    // lib.optionalAttrs (show != "changes") {
      stateFilter = stateFilter;
    }
    // {
      onlyAlertsOnDashboard = onlyAlertsOnDashboard;
    }
    // lib.optionalAttrs (description != null) {
      description = description;
    }
    // {
      datasource = datasource;
    };
}
