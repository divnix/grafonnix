{
  nixlib,
  POP,
}: {
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
    POP.lib.pop {
      defaults =
        {
          inherit title;
          type = "heatmap";
        }
        // nixlib.lib.optionalAttrs (description != null) {
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
            // nixlib.lib.optionalAttrs (color_mode == "spectrum") {
              colorScheme = color_colorScheme;
            }
            // nixlib.lib.optionalAttrs (color_max != null) {
              inherit color_max;
            }
            // nixlib.lib.optionalAttrs (color_min != null) {
              inherit color_min;
            };
        }
        // nixlib.lib.optionalAttrs (dataFormat != null) {
          inherit dataFormat;
        }
        // {
          heatmap = {};
          inherit hideZeroBuckets;
          inherit highlightCards;
          legend.show = legend_show;
        }
        // nixlib.lib.optionalAttrs (minSpan != null) {
          inherit minSpan;
        }
        // nixlib.lib.optionalAttrs (span != null) {
          inherit span;
        }
        // nixlib.lib.optionalAttrs (repeat != null) {
          inherit repeat;
        }
        // nixlib.lib.optionalAttrs (repeatDirection != null) {
          inherit repeatDirection;
        }
        // {
          tooltip = {
            show = tooltip_show;
            showHistogram = tooltip_showHistogram;
          };
        }
        // nixlib.lib.optionalAttrs (tooltipDecimals != null) {
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
            // nixlib.lib.optionalAttrs (dataFormat == "timeseries") {
              logBase = yAxis_logBase;
              max = yAxis_max;
              min = yAxis_min;
            };
          inherit yBucketBound;
        }
        // nixlib.lib.optionalAttrs (dataFormat == "timeseries") {
          inherit yBucketNumber;
          inherit yBucketSize;
        }
        // nixlib.lib.optionalAttrs (maxDataPoints != null) {
          inherit maxDataPoints;
        }
        // {
          targets = [];
          _nextTarget = 0;
        };

      extenders = let
        addTarget = target: self: super: let
          letters = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"];
          refId = builtins.elemAt letters super._nextTarget;
          newTarget = POP.lib.pop {
            supers = [target];
            defaults = {inherit refId;};
          };
        in {
          _nextTarget = super._nextTarget + 1;
          targets = super.targets ++ [newTarget];
        };
      in {
        inherit addTarget;
        addTargets = targets: self: super: {
          targets = super.targets ++ (map (t: ))
        };
      }
    };
}
