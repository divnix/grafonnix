{lib}: {
  /*
    *
   * Creates a [Google Cloud Monitoring target](https://grafana.com/docs/grafana/latest/datasources/google-cloud-monitoring/)
   *
   * @name cloudmonitoring.target
   *
   * @param metric
   * @param project
   * @param filters (optional)
   * @param groupBys (optional)
   * @param period (default: `"cloud-monitoring-auto"`)
   * @param crossSeriesReducer (default "REDUCE_MAX")
   * @param valueType (default "INT64")
   * @param perSeriesAligner (default "ALIGN_DELTA")
   * @param metricKind (default "CUMULATIVE")
   * @param unit (optional)
   * @param alias (optional)
   
   * @return Panel target
   */

  target = {
    metric,
    project,
    filters ? [],
    groupBys ? [],
    period ? "cloud-monitoring-auto",
    crossSeriesReducer ? "REDUCE_MAX",
    valueType ? "INT64",
    perSeriesAligner ? "ALIGN_DELTA",
    metricKind ? "CUMULATIVE",
    unit ? 1,
    alias ? null,
  }:
    lib.kPop {
      metricQuery =
        lib.optionalAttrs (alias != null) {
          aliasBy = alias;
        }
        // {
          alignmentPeriod = period;
          crossSeriesReducer = crossSeriesReducer;
        }
        // lib.optionalAttrs (filters != null) {
          filters = filters;
        }
        // lib.optionalAttrs (groupBys != null) {
          groupBys = groupBys;
        }
        // {
          metricKind = metricKind;
          metricType = metric;
          perSeriesAligner = perSeriesAligner;
          projectName = project;
          unit = unit;
          valueType = valueType;
        };
      sloQuery =
        lib.optionalAttrs (alias != null) {
          aliasBy = alias;
        }
        // {
          alignmentPeriod = period;
          projectName = project;
          selectorName = "select_slo_health";
          serviceId = "";
          sloId = "";
        };
    };
}
