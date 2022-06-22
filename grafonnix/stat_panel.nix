{lib}: {
  /*
    *
   * Creates a [stat panel](https://grafana.com/docs/grafana/latest/panels/visualizations/stat-panel/).
   *
   * @name statPanel.new
   *
   * @param title Panel title.
   * @param description (optional) Panel description.
   * @param transparent (default `false`) Whether to display the panel without a background.
   * @param datasource (optional) Panel datasource.
   * @param allValues (default `false`) Show all values instead of reducing to one.
   * @param valueLimit (optional) Limit of values in all values mode.
   * @param reducerFunction (default `"mean"`) Function to use to reduce values to when using single value.
   * @param fields (default `""`) Fields that should be included in the panel.
   * @param orientation (default `"auto"`) Stacking direction in case of multiple series or fields.
   * @param colorMode (default `"value"`) "value" or "background".
   * @param graphMode (default `"area"`) "none" or "area" to enable sparkline mode.
   * @param textMode (default `"auto"`) Control if name and value is displayed or just name.
   * @param justifyMode (default `"auto"`) "auto" or "center".
   * @param unit (default `"none"`) Panel unit field option.
   * @param min (optional) Leave empty to calculate based on all values.
   * @param max (optional) Leave empty to calculate based on all values.
   * @param decimals (optional) Number of decimal places to show.
   * @param displayName (optional) Change the field or series name.
   * @param noValue (optional) What to show when there is no value.
   * @param thresholdsMode (default `"absolute"`) "absolute" or "percentage".
   * @param timeFrom (optional) Override the relative time range.
   * @param repeat (optional) Name of variable that should be used to repeat this panel.
   * @param repeatDirection (default `"h"`) "h" for horizontal or "v" for vertical.
   * @param maxPerRow (optional) Maximum panels per row in repeat mode.
   * @param pluginVersion (default `"7"`) Plugin version the panel should be modeled for. This has been tested with the default, "7", and "6.7".
   *
   * @method addTarget(target) Adds a target object.
   * @method addTargets(targets) Adds an array of targets.
   * @method addLink(link) Adds a [panel link](https://grafana.com/docs/grafana/latest/linking/panel-links/). Argument format: `{ title: "Link Title", url: "https://...", targetBlank: true }`.
   * @method addLinks(links) Adds an array of links.
   * @method addThreshold(step) Adds a [threshold](https://grafana.com/docs/grafana/latest/panels/thresholds/) step. Argument format: `{ color: "green", value: 0 }`.
   * @method addThresholds(steps) Adds an array of threshold steps.
   * @method addMapping(mapping) Adds a value mapping.
   * @method addMappings(mappings) Adds an array of value mappings.
   * @method addDataLink(link) Adds a data link.
   * @method addDataLinks(links) Adds an array of data links.
   */
  new = {
    title,
    description ? null,
    transparent ? false,
    datasource ? null,
    allValues ? false,
    valueLimit ? null,
    reducerFunction ? "mean",
    fields ? "",
    orientation ? "auto",
    colorMode ? "value",
    graphMode ? "area",
    textMode ? "auto",
    justifyMode ? "auto",
    unit ? "none",
    min ? null,
    max ? null,
    decimals ? null,
    displayName ? null,
    noValue ? null,
    thresholdsMode ? "absolute",
    timeFrom ? null,
    repeat ? null,
    repeatDirection ? "h",
    maxPerRow ? null,
    pluginVersion ? "7",
  }:
    lib.pop {
      visibility = {
        _nextTarget = false;
        _nextMapping = false;
        addTarget = false;
        addTargets = false;
        addLink = false;
        addLinks = false;
        addThreshold = false;
        addMapping = false;
        addDataLink = false;
        addOverride = false;
        addOverrides = false;
        addThresholds = false;
        addMappings = false;
        addDataLinks = false;
      };

      extension = self: super:
        {
          type = "stat";
          title = title;
        }
        // lib.optionalAttrs (description != null) {
          description = description;
        }
        // {
          transparent = transparent;
          datasource = datasource;
          targets = [];
          links = [];
        }
        // lib.optionalAttrs (repeat != null) {
          repeat = repeat;
        }
        // lib.optionalAttrs (repeat != null) {
          repeatDirection = repeatDirection;
        }
        // lib.optionalAttrs (timeFrom != null) {
          timeFrom = timeFrom;
        }
        // lib.optionalAttrs (repeat != null) {
          maxPerRow = maxPerRow;
        }
        // {
          # targets
          _nextTarget = 0;
          addTarget = target:
            lib.extendPop self (self: super: {
              _nextTarget = super._nextTarget + 1;
              targets = let
                letters = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"];
                refId = builtins.elemAt letters super._nextTarget;
                newTarget = lib.kxPop target {
                  inherit refId;
                };
              in
                super.targets ++ [newTarget];
            });
          addTargets = targets: lib.foldl (p: t: p.addTarget t) self targets;

          # links
          addLink = link:
            lib.extendPop self (self: super: {
              links = super.links ++ [link];
            });
          addLinks = links:
            lib.foldl (p: t: p.addLink t) self links;

          pluginVersion = pluginVersion;
        }
        // (
          if pluginVersion >= "7"
          then {
            options = {
              reduceOptions =
                {
                  values = allValues;
                }
                // lib.optionalAttrs (allValues && valueLimit != null) {
                  limit = valueLimit;
                }
                // {
                  calcs = [
                    reducerFunction
                  ];
                  fields = fields;
                };
              orientation = orientation;
              colorMode = colorMode;
              graphMode = graphMode;
              justifyMode = justifyMode;
              textMode = textMode;
            };
            fieldConfig = {
              defaults =
                {
                  unit = unit;
                }
                // lib.optionalAttrs (min != null) {
                  min = min;
                }
                // lib.optionalAttrs (max != null) {
                  max = max;
                }
                // lib.optionalAttrs (decimals != null) {
                  decimals = decimals;
                }
                // lib.optionalAttrs (displayName != null) {
                  displayName = displayName;
                }
                // lib.optionalAttrs (noValue != null) {
                  noValue = noValue;
                }
                // {
                  thresholds = {
                    mode = thresholdsMode;
                    steps = [];
                  };
                  mappings = [];
                  links = [];
                };
            };

            # thresholds
            addThreshold = step:
              lib.extendPop self (self: super: {
                fieldConfig = lib.recursiveUpdate super.fieldConfig {
                  defaults.thresholds.steps =
                    super.fieldConfig.defaults.threshholds.steps ++ [step];
                };
              });

            # mappings
            _nextMapping = 0;
            addMapping = mapping:
              lib.extendPop self (self: super: let
                nextMapping = super._nextMapping;
              in {
                _nextMapping = nextMapping + 1;
                fieldConfig =
                  lib.recursiveUpdate super.fieldConfig
                  {defaults.mappings = super.fieldConfig.defaults.mappings ++ [(mapping {id = nextMapping;})];};
              });

            # data links
            addDataLink = link:
              lib.extendPop self (self: super: {
                fieldConfig =
                  lib.recursiveUpdate super.fieldConfig
                  {defaults.links = super.fieldConfig.defaults.links ++ [link];};
              });

            # Overrides
            addOverride = {
              matcher ? null,
              properties ? null,
            }:
              lib.extendPop self (self: super: {
                fieldConfig = lib.recursiveUpdate super.fieldConfig {
                  overrides =
                    super.fieldConfig.overrides
                    ++ [
                      (lib.optionalAttrs (matcher != null) {
                          matcher = matcher;
                        }
                        // lib.optionalAttrs (properties != null) {
                          properties = properties;
                        })
                    ];
                };
              });

            addOverrides = overrides: lib.foldl (p: o: p.addOverride {inherit (o) matcher properties;}) self overrides;
          }
          else {
            options = {
              fieldOptions =
                {
                  values = allValues;
                }
                // lib.optionalAttrs (allValues && valueLimit != null) {
                  limit = valueLimit;
                }
                // {
                  calcs = [
                    reducerFunction
                  ];
                  fields = fields;
                  defaults =
                    {
                      unit = unit;
                    }
                    // lib.optionalAttrs (min != null) {
                      min = min;
                    }
                    // lib.optionalAttrs (max != null) {
                      max = max;
                    }
                    // lib.optionalAttrs (decimals != null) {
                      decimals = decimals;
                    }
                    // lib.optionalAttrs (displayName != null) {
                      displayName = displayName;
                    }
                    // lib.optionalAttrs (noValue != null) {
                      noValue = noValue;
                    }
                    // {
                      thresholds = {
                        mode = thresholdsMode;
                        steps = [];
                      };
                      mappings = [];
                      links = [];
                    };
                };
              orientation = orientation;
              colorMode = colorMode;
              graphMode = graphMode;
              justifyMode = justifyMode;
            };
            # thresholds
            addThreshhold = step:
              lib.extendPop self (self: super: {
                fieldOptions = lib.recursiveUpdate super.fieldConfig {
                  defaults.thresholds.steps =
                    super.fieldOptions.defaults.threshholds.steps ++ [step];
                };
              });

            # mappings
            addMapping = mapping:
              lib.extendPop self (self: super: let
                nextMapping = super._nextMapping;
              in {
                _nextMapping = nextMapping + 1;
                fieldOptions =
                  lib.recursiveUpdate super.fieldConfig
                  {defaults.mappings = super.fieldOptions.defaults.mappings ++ [(mapping {id = nextMapping;})];};
              });

            # data links
            addDataLink = link:
              lib.extendPop self (self: super: {
                fieldOptions =
                  lib.recursiveUpdate super.fieldConfig
                  {defaults.links = super.fieldOptions.defaults.links ++ [link];};
              });
          }
        )
        // {
          addThresholds = steps: lib.foldl (p: s: p.addThreshold s) self steps;
          addMappings = mappings: lib.foldl (p: m: p.addMapping m) self mappings;
          addDataLinks = links: lib.foldl (p: l: p.addDataLink l) self links;
        };
    };
}
