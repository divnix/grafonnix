{lib}: {
  /*
    *
   * Returns a new condition of alert of graph panel.
   * Currently the only condition type that exists is a Query condition
   * that allows to specify a query letter, time range and an aggregation function.
   *
   * @name alertCondition.new
   *
   * @param evaluatorParams Value of threshold
   * @param evaluatorType Type of threshold
   * @param operatorType Operator between conditions
   * @param queryRefId The letter defines what query to execute from the Metrics tab
   * @param queryTimeStart Begging of time range
   * @param queryTimeEnd End of time range
   * @param reducerParams Params of an aggregation function
   * @param reducerType Name of an aggregation function
   *
   * @return A json that represents a condition of alert
   */
  new = {
    evaluatorParams ? [],
    evaluatorType ? "gt",
    operatorType ? "and",
    queryRefId ? "A",
    queryTimeEnd ? "now",
    queryTimeStart ? "5m",
    reducerParams ? [],
    reducerType ? "avg",
  }:
    lib.kPop
    {
      evaluator = {
        params =
          if builtins.isList evaluatorParams
          then evaluatorParams
          else [evaluatorParams];
        type = evaluatorType;
      };
      operator = {
        type = operatorType;
      };
      query = {
        params = [queryRefId queryTimeStart queryTimeEnd];
      };
      reducer = {
        params =
          if builtins.isList reducerParams
          then reducerParams
          else [reducerParams];
        type = reducerType;
      };
      type = "query";
    };
}
