{lib}: let
  outer = {
    /*
      *
     * Creates a [template](https:#grafana.com/docs/grafana/latest/variables/#templates) that can be added to a dashboard.
     *
     * @name template.new
     *
     * @param name Name of variable.
     * @param datasource Template [datasource](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-data-source-variable/)
     * @param query [Query expression](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-query-variable/) for the datasource.
     * @param label (optional) Display name of the variable dropdown. If null, then the dropdown label will be the variable name.
     * @param allValues (optional) Formatting for [multi-value variables](https:#grafana.com/docs/grafana/latest/variables/formatting-multi-value-variables/#formatting-multi-value-variables)
     * @param tagValuesQuery (default `""`) Group values into [selectable tags](https:#grafana.com/docs/grafana/latest/variables/variable-value-tags/)
     * @param current (default `null`) Can be `null`, `"all"` for all, or any other custom text value.
     * @param hide (default `""`) `""`: the variable dropdown displays the variable Name or Label value. `"label"`: the variable dropdown only displays the selected variable value and a down arrow. Any other value: no variable dropdown is displayed on the dashboard.
     * @param regex (default `""`) Regex expression to filter or capture specific parts of the names returned by your data source query. To see examples, refer to [Filter variables with regex](https:#grafana.com/docs/grafana/latest/variables/filter-variables-with-regex/).
     * @param refresh (default `"never"`) `"never"`: variables queries are cached and values are not updated. This is fine if the values never change, but problematic if they are dynamic and change a lot. `"load"`: Queries the data source every time the dashboard loads. This slows down dashboard loading, because the variable query needs to be completed before dashboard can be initialized. `"time"`: Queries the data source when the dashboard time range changes. Only use this option if your variable options query contains a time range filter or is dependent on the dashboard time range.
     * @param includeAll (default `false`) Whether all value option is available or not.
     * @param multi (default `false`) Whether multiple values can be selected or not from variable value list.
     * @param sort (default `0`) `0`: Without Sort, `1`: Alphabetical (asc), `2`: Alphabetical (desc), `3`: Numerical (asc), `4`: Numerical (desc).
     *
     * @return A [template](https:#grafana.com/docs/grafana/latest/variables/#templates)
     */
    new = {
      name,
      datasource,
      query,
      label ? null,
      allValues ? null,
      tagValuesQuery ? "",
      current ? null,
      hide ? "",
      regex ? "",
      refresh ? "never",
      includeAll ? false,
      multi ? false,
      sort ? 0,
    }:
      lib.kPop
      {
        allValue = allValues;
        current = current;
        datasource = datasource;
        includeAll = includeAll;
        hide = hide;
        label = label;
        multi = multi;
        name = name;
        options = [];
        query = query;
        refresh = refresh;
        regex = regex;
        sort = sort;
        tagValuesQuery = tagValuesQuery;
        tags = [];
        tagsQuery = "";
        type = "query";
        useTags = false;
      };
    /*
      *
     * Use an [interval variable](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-interval-variable/) to represent time spans such as "1m", "1h", "1d". You can think of them as a dashboard-wide "group by time" command. Interval variables change how the data is grouped in the visualization. You can also use the Auto Option to return a set number of data points per time span.
     * You can use an interval variable as a parameter to group by time (for InfluxDB), date histogram interval (for Elasticsearch), or as a summarize function parameter (for Graphite).
     *
     * @name template.interval
     *
     * @param name Variable name
     * @param query Comma separated values without spacing of intervals available for selection. Add `"auto"` in the query to turn on the Auto Option. Ex: `"auto,5m,10m,20m"`.
     * @param current Currently selected interval. Must be one of the values in the query. `"auto"` is allowed if defined in the query.
     * @param hide (default `""`) `""`: the variable dropdown displays the variable Name or Label value. `"label"`: the variable dropdown only displays the selected variable value and a down arrow. Any other value: no variable dropdown is displayed on the dashboard.
     * @param label (optional) Display name of the variable dropdown. If null, then the dropdown label will be the variable name.
     * @param auto_count (default `300`) Valid only if `"auto"` is defined in query. Number of times the current time range will be divided to calculate the value, similar to the Max data points query option. For example, if the current visible time range is 30 minutes, then the auto interval groups the data into 30 one-minute increments. The default value is 30 steps.
     * @param auto_min (default `"10s"`) Valid only if `"auto"` is defined in query. The minimum threshold below which the step count intervals will not divide the time. To continue the 30 minute example, if the minimum interval is set to `"2m"`, then Grafana would group the data into 15 two-minute increments.
     *
     * @return A new interval variable for templating.
     */
    interval = {
      name,
      query,
      current,
      hide ? "",
      label ? null,
      auto_count ? 300,
      auto_min ? "10s",
    }:
      lib.pop
      {
        extension = self: super: {
          current = self.getCurrentValue current;
          hide = self.getHideValue hide;
          label = label;
          name = name;
          query = lib.concatStringsSep "," (
            builtins.filter outer.filterAuto (lib.splitString "," query)
          );
          refresh = 2;
          type = "interval";
          auto = lib.count (s: s == "auto") (lib.splitString "," query) > 0;
          auto_count = auto_count;
          auto_min = auto_min;
        };
      };

    hide = hide:
      if hide == ""
      then 0
      else if hide == "label"
      then 1
      else 2;

    current = current:
      lib.optionalAttrs (current != null) {
        text = current;
        value =
          if current == "auto"
          then "outer__auto_interval"
          else if current == "all"
          then "outer__all"
          else current;
      };

    /*
      *
     * Data [source variables](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-data-source-variable/)
     * allow you to quickly change the data source for an entire dashboard.
     * They are useful if you have multiple instances of a data source, perhaps in different environments.
     *
     * @name template.datasource
     *
     * @param name Data source variable name. Ex: `"PROMETHEUS_DS"`.
     * @param query Type of data source. Ex: `"prometheus"`.
     * @param current Ex: `"Prometheus"`.
     * @param hide (default `""`) `""`: the variable dropdown displays the variable Name or Label value. `"label"`: the variable dropdown only displays the selected variable value and a down arrow. Any other value: no variable dropdown is displayed on the dashboard.
     * @param label (optional) Display name of the variable dropdown. If null, then the dropdown label will be the variable name.
     * @param regex (default `""`) Regex filter for which data source instances to choose from in the variable value drop-down list. Leave this field empty to display all instances.
     * @param refresh (default `"load"`) `"never"`: Variables queries are cached and values are not updated. This is fine if the values never change, but problematic if they are dynamic and change a lot. `"load"`: Queries the data source every time the dashboard loads. This slows down dashboard loading, because the variable query needs to be completed before dashboard can be initialized. `"time"`: Queries the data source when the dashboard time range changes. Only use this option if your variable options query contains a time range filter or is dependent on the dashboard time range.
     *
     * @return A [data source variable](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-data-source-variable/).
     */
    datasource = {
      name,
      query,
      current,
      hide ? "",
      label ? null,
      regex ? "",
      refresh ? "load",
    }:
      lib.pop {
        extension = self: super: {
          current = outer.current current;
          hide = outer.hide hide;
          label = label;
          name = name;
          options = [];
          query = query;
          refresh = outer.refresh refresh;
          regex = regex;
          type = "datasource";
        };
      };

    refresh = refresh:
      if refresh == "never"
      then 0
      else if refresh == "load"
      then 1
      else if refresh == "time"
      then 2
      else refresh;

    filterAuto = str: str != "auto";
    /*
      *
     * Use a [custom variable](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-custom-variable/)
     * for values that do not change.
     *
     * @name template.custom
     * This might be numbers, strings, or even other variables.
     * @param name Variable name
     * @param query Comma separated without spacing list of selectable values.
     * @param current Selected value
     * @param refresh (default `"never"`) `"never"`: Variables queries are cached and values are not updated. This is fine if the values never change, but problematic if they are dynamic and change a lot. `"load"`: Queries the data source every time the dashboard loads. This slows down dashboard loading, because the variable query needs to be completed before dashboard can be initialized. `"time"`: Queries the data source when the dashboard time range changes. Only use this option if your variable options query contains a time range filter or is dependent on the dashboard time range.
     * @param label (default `""`) Display name of the variable dropdown. If you don’t enter a display name, then the dropdown label will be the variable name.
     * @param valuelabels (default `{}`) Display names for values defined in query. For example, if `query="new,old"`, then you may display them as follows `valuelabels={new: "nouveau", old: "ancien"}`.
     * @param multi (default `false`) Whether multiple values can be selected or not from variable value list.
     * @param allValues (optional) Formatting for [multi-value variables](https:#grafana.com/docs/grafana/latest/variables/formatting-multi-value-variables/#formatting-multi-value-variables)
     * @param includeAll (default `false`) Whether all value option is available or not.
     * @param hide (default `""`) `""`: the variable dropdown displays the variable Name or Label value. `"label"`: the variable dropdown only displays the selected variable value and a down arrow. Any other value: no variable dropdown is displayed on the dashboard.
     *
     * @return A custom variable.
     */
    custom = {
      name,
      query,
      current,
      refresh ? "never",
      label ? "",
      valuelabels ? {},
      multi ? false,
      allValues ? null,
      includeAll ? false,
      hide ? "",
    }:
      lib.pop
      {
        visibility = {
          "query_array" = false;
        };
        extension = self: super: let
          # self has dynamic scope, so self may not be myself below.
          # "outer" can"t be used neither as this object is not top-level object.
          custom = self;
        in {
          allValue = allValues;
          current =
            {
              # Both "all" and "All" are accepted for consistency.
              value =
                if includeAll && (current == "All" || current == "all")
                then
                  if multi
                  then ["outer__all"]
                  else "outer__all"
                else current;
              text =
                if builtins.isList current
                then
                  lib.concatStringsSep " + " (
                    map custom.valuelabel current
                  )
                else custom.valuelabel current;
            }
            // lib.optionalAttrs multi {
              selected = true;
            };
          options = map self.option (self.query_array query);
          hide = outer.hide hide;
          includeAll = includeAll;
          label = label;
          refresh = outer.refresh refresh;
          multi = multi;
          name = name;
          query = query;
          type = "custom";

          valuelabel = value:
            if lib.elem value valuelabels
            then builtins.elemAt valuelabels value
            else value;

          option = option:
            {
              text = custom.valuelabel option;
              value =
                if includeAll && option == "All"
                then "outer__all"
                else option;
            }
            // lib.optionalAttrs multi {
              selected =
                if multi && builtins.isList current
                then builtins.elem option current
                else if multi
                then current == option
                else null;
            };

          query_array = query:
            lib.splitString "," (
              if includeAll
              then "All;" + query
              else query
            );
        };
      };
    /*
      *
     * [Text box variables](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-text-box-variable/)
     * display a free text input field with an optional default value.
     * This is the most flexible variable, because you can enter any value.
     * Use this type of variable if you have metrics with high cardinality or if you want to
     * update multiple panels in a dashboard at the same time.
     *
     * @name template.text
     *
     * @param name Variable name.
     * @param label (default `""`) Display name of the variable dropdown. If you don’t enter a display name, then the dropdown label will be the variable name.
     *
     * @return A text box variable.
     */
    text = {
      name,
      label ? "",
    }:
      lib.kPop {
        current = {
          selected = false;
          text = "";
          value = "";
        };
        name = name;
        label = label;
        query = "";
        type = "textbox";
      };
    /*
      *
     * [Ad hoc filters](https:#grafana.com/docs/grafana/latest/variables/variable-types/add-ad-hoc-filters/)
     * allow you to add key/value filters that are automatically added to all metric queries
     * that use the specified data source. Unlike other variables, you do not use ad hoc filters in queries.
     * Instead, you use ad hoc filters to write filters for existing queries.
     * Note: Ad hoc filter variables only work with InfluxDB, Prometheus, and Elasticsearch data sources.
     *
     * @name template.adhoc
     *
     * @param name Variable name.
     * @param datasource Target data source
     * @param label (optional) Display name of the variable dropdown. If you don’t enter a display name, then the dropdown label will be the variable name.
     * @param hide (default `""`) `""`: the variable dropdown displays the variable Name or Label value. `"label"`: the variable dropdown only displays the selected variable value and a down arrow. Any other value: no variable dropdown is displayed on the dashboard.
     *
     * @return An ad hoc filter
     */
    adhoc = {
      name,
      datasource,
      label ? null,
      hide ? "",
    }:
      lib.kPop {
        datasource = datasource;
        hide = outer.hide hide;
        label = label;
        name = name;
        type = "adhoc";
      };
  };
in
  outer
