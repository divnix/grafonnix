{lib}: {
  /*
    *
   * Creates an [InfluxDB target](https://grafana.com/docs/grafana/latest/datasources/influxdb/)
   *
   * @name influxdb.target
   *
   * @param query Raw InfluxQL statement
   *
   * @param alias (optional) "Alias By" pattern
   * @param datasource (optional) Datasource
   * @param hide (optional) Disable query on graph
   *
   * @param rawQuery (optional) Enable/disable raw query mode
   *
   * @param policy (default: `"default"`) Tagged query "From" policy
   * @param measurement (optional) Tagged query "From" measurement
   * @param group_time (default: `"$__interval"`) "Group by" time condition (if set to null, do not groups by time)
   * @param group_tags (optional) "Group by" tags list
   * @param fill (default: `"none"`) "Group by" missing values fill mode (works only with "Group by time()")
   *
   * @param resultFormat (default: `"time_series"`) Format results as "Time series" or "Table"
   *
   * @return Panel target
   */
  target = {
    query ? null,
    alias ? null,
    datasource ? null,
    hide ? null,
    rawQuery ? null,
    policy ? "default",
    measurement ? null,
    group_time ? "$__interval",
    group_tags ? [],
    fill ? "none",
    resultFormat ? "time_series",
  }:
    lib.pop {
      extension = self: super: let
        it = self;
      in
        lib.optionalAttrs (alias != null) {
          inherit alias;
        }
        // lib.optionalAttrs (datasource != null) {
          inherit datasource;
        }
        // lib.optionalAttrs (hide != null) {
          inherit hide;
        }
        // lib.optionalAttrs (query != null) {
          inherit query;
        }
        // lib.optionalAttrs (rawQuery != null) {
          inherit rawQuery;
        }
        // lib.optionalAttrs (rawQuery == null && query != null) {
          rawQuery = true;
        }
        // {
          policy = policy;
        }
        // lib.optionalAttrs (measurement != null) {
          inherit measurement;
        }
        // {
          tags = [];
          select = [];
          groupBy =
            if group_time != null
            then
              [
                {
                  type = "time";
                  params = [group_time];
                }
              ]
              ++ (map (tag_name: {
                  type = "tag";
                  params = [tag_name];
                })
                group_tags)
              ++ [
                {
                  type = "fill";
                  params = [fill];
                }
              ]
            else
              map (tag_name: {
                type = "tag";
                params = [tag_name];
              })
              group_tags;

          resultFormat = resultFormat;

          where = {
            key,
            operator,
            value,
            condition ? null,
          }:
            self (self: super: {
              /*
               * Adds query tag condition ("Where" section)
               */
              tags =
                if lib.length it.tags == 0
                then [
                  {
                    key = key;
                    operator = operator;
                    value = value;
                  }
                ]
                else
                  it.tags
                  ++ [
                    {
                      key = key;
                      operator = operator;
                      value = value;
                      condition =
                        if condition == null
                        then "AND"
                        else condition;
                    }
                  ];
            });

          selectField = value:
            self (self: super: {
              /*
               * Adds InfluxDB selection ("field(value)" part of "Select" statement)
               */
              select =
                super.select
                ++ [
                  [
                    {
                      params = [value];
                      type = "field";
                    }
                  ]
                ];
            });

          addConverter = {
            type,
            params ? [],
          }:
            self (self: super: let
              /*
               * Appends converter (aggregation, selector, etc.) to last added selection
               */
              len = lib.length it.select;
            in {
              select =
                if len == 1
                then [
                  ((lib.elemAt it.select 0)
                    ++ [
                      {
                        params = params;
                        type = type;
                      }
                    ])
                ]
                else if len > 1
                then
                  (lib.sublist 0 (len - 1) it.select)
                  ++ [
                    ((lib.elemAt it.select (len - 1))
                      ++ [
                        {
                          params = params;
                          type = type;
                        }
                      ])
                  ]
                else [];
            });
        };
    };
}
