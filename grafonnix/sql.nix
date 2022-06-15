{ POP, nixlib }:
{
  /**
   * Creates an SQL target.
   *
   * @name sql.target
   *
   * @param rawSql The SQL query
   * @param datasource (optional)
   * @param format (default `"time_series"`)
   * @param alias (optional)
   */
  target = {
    rawSql,
    datasource?null,
    format?"time_series",
    alias?null,
  }: POP.lib.kPop
    (nixlib.lib.optionalAttrs (datasource != null){
      datasource= datasource;
    }) // {
    format= format;
    } // nixlib.lib.optionalAttrs (alias != null) {
    alias= alias;
    }// {
    rawSql= rawSql;
    };
}
