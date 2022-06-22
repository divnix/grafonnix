{lib}: {
  new = {
    title,
    datasource ? null,
    description ? null,
    cards_cardPadding ? null,
    cards_cardRound ? null,
    color_cardColor ? "#b4ff00",
    color_colorScale ? "sqrt",
    color_colorScheme ? "interpolateOranges",
    color_exponent ? 0.5,
    color_max ? null,
    color_min ? null,
    color_mode ? "spectrum",
    dataFormat ? "timeseries",
    highlightCards ? true,
    hideZeroBuckets ? false,
    legend_show ? false,
    minSpan ? null,
    span ? null,
    repeat ? null,
    repeatDirection ? null,
    tooltipDecimals ? null,
    tooltip_show ? true,
    tooltip_showHistogram ? false,
    xAxis_show ? true,
    xBucketNumber ? null,
    xBucketSize ? null,
    yAxis_decimals ? null,
    yAxis_format ? "short",
    yAxis_logBase ? 1,
    yAxis_min ? null,
    yAxis_max ? null,
    yAxis_show ? true,
    yAxis_splitFactor ? null,
    yBucketBound ? "auto",
    yBucketNumber ? null,
    yBucketSize ? null,
    maxDataPoints ? null,
  }:
    lib.pop {
      visibility = {
        _nextTarget = false;
        addTarget = false;
        addTargets = false;
      };

      defaults =
        {
          inherit title;
          type = "heatmap";
        }
        // lib.optionalAttrs (description != null) {
          inherit description;
        }
        // {
          cards = {
            cardPadding = cards_cardPadding;
            cardRound = cards_cardRound;
          };
          color =
            {
              mode = color_mode;
              cardColor = color_cardColor;
              exponent = color_exponent;
              max = color_max;
              min = color_min;
            }
            // lib.optionalAttrs (color_mode == "spectrum") {
              colorScheme = color_colorScheme;
            }
            // lib.optionalAttrs (color_max != null) {
              inherit color_max;
            }
            // lib.optionalAttrs (color_min != null) {
              inherit color_min;
            };
        }
        // lib.optionalAttrs (dataFormat != null) {
          inherit dataFormat;
        }
        // {
          heatmap = {};
          inherit hideZeroBuckets;
          inherit highlightCards;
          legend.show = legend_show;
        }
        // lib.optionalAttrs (minSpan != null) {
          inherit minSpan;
        }
        // lib.optionalAttrs (span != null) {
          inherit span;
        }
        // lib.optionalAttrs (repeat != null) {
          inherit repeat;
        }
        // lib.optionalAttrs (repeatDirection != null) {
          inherit repeatDirection;
        }
        // {
          tooltip = {
            show = tooltip_show;
            showHistogram = tooltip_showHistogram;
          };
        }
        // lib.optionalAttrs (tooltipDecimals != null) {
          inherit tooltipDecimals;
        }
        // {
          xAxis.show = xAxis_show;
          xBucketNumber =
            if dataFormat == "timeseries" && xBucketSize != null
            then xBucketNumber
            else null;
          xBucketSize =
            if dataFormat == "timeseries" && xBucketSize != null
            then xBucketSize
            else null;
          yAxis =
            {
              decimals = yAxis_decimals;
              format = yAxis_format;
              show = yAxis_show;
              splitFactor = yAxis_splitFactor;
            }
            // lib.optionalAttrs (dataFormat == "timeseries") {
              logBase = yAxis_logBase;
              max = yAxis_max;
              min = yAxis_min;
            };
          inherit yBucketBound;
        }
        // lib.optionalAttrs (dataFormat == "timeseries") {
          inherit yBucketNumber;
          inherit yBucketSize;
        }
        // lib.optionalAttrs (maxDataPoints != null) {
          inherit maxDataPoints;
        }
        // {
          targets = [];
          _nextTarget = 0;
        };

      extension = self: super: {
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
      };
    };
}
