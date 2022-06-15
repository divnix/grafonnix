{ POP, nixlib }:
{
  /**
   * Creates a [CloudWatch target](https://grafana.com/docs/grafana/latest/datasources/cloudwatch/)
   *
   * @name cloudwatch.target
   *
   * @param region
   * @param namespace
   * @param metric
   * @param datasource (optional)
   * @param statistic (default: `"Average"`)
   * @param alias (optional)
   * @param highResolution (default: `false`)
   * @param period (default: `"auto"`)
   * @param dimensions (optional)
   * @param id (optional)
   * @param expression (optional)
   * @param hide (optional)

   * @return Panel target
   */

  target = {
    region,
    namespace,
    metric,
    datasource?null,
    statistic?"Average",
    alias?null,
    highResolution?false,
    period?"auto",
    dimensions?{},
    id?null,
    expression?null,
    hide?null
  }: nixlib.lib.kPop {
    region= region;
    namespace= namespace;
    metricName= metric;
  } // nixlib.lib.optionalAttrs (datasource != null) { datasource= datasource; }
  // {
    statistics= [statistic];
  } // nixlib.lib.optionalAttrs (alias != null) { alias= alias; }
  // {
    highResolution= highResolution;
    period= period;
    dimensions= dimensions;
  } // nixlib.lib.optionalAttrs (id != null) { id= id; }
  // nixlib.lib.optionalAttrs (expression != null) {expression= expression;}
  // nixlib.lib.optionalAttrs (hide != null) {hide= hide;};

}
