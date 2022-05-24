{
  inputs.yants.url = "github:divnix/yants";
  inputs.nixlib.url = "github:nix-community/nixpkgs.lib";

  outputs = {
    self,
    yants,
    nixlib,
  }: {
    lib = let
      filterNull = nixlib.lib.filterAttrsRecursive (n: v: v != null);
    in {
      row.new = {
        title ? "Dashboard Row",
        height ? null,
        collapse ? false,
        repeat ? null,
        showTitle ? null,
        titleSize ? "h6",
      }: let
        addPanels = self: { panels }: let out = self // { addPanels = addPanels out; panels = self.panels ++ panels; }; in out;
        final = {
          inherit
            title
            titleSize
            collapse
            repeat
            height
            ;
          type = "row";
          collapsed = collapse;
          panels = [];
          repeatIteration = null;
          repeatRowId = null;
          showTitle =
            if showTitle != null
            then showTitle
            else title != "Dashboard Row";
          /** addPanel = {
            panel,
            gridPos ? {},
          }:
            self
            // {
              panels = self.panels ++ [(panel // {inherit gridPos;})];
            }**/;
        };
      in
        final // { addPanels = addPanels final; };

      heatmap_panel.new = {
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
      }: let
        self =
          {
            inherit
              title
              datasource
              hideZeroBuckets
              highlightCards
              yBucketBound
              description
              dataFormat
              minSpan
              span
              repeat
              repeatDirection
              maxDataPoints
              ;
            type = "heatmap";
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
              };
            heatmap = {};
            legend.show = legend_show;
            tooltip = {
              show = tooltip_show;
              showHistogram = tooltip_showHistogram;
            };
            xAxis.show = xAxis_show;
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
            targets = [];
            _nextTarget = 0;
            addTarget = {target}: let
              letters = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P"];
              newTarget =
                target
                // {
                  refId = builtins.elemAt letters self._nextTarget;
                };
            in
              self
              // {
                _nextTarget = self._nextTarget + 1;
                targets = self.targets ++ [newTarget];
              };
          }
          // nixlib.lib.optionalAttrs (dataFormat == "timeseries") {
            inherit yBucketNumber yBucketSize xBucketNumber xBucketSize;
          };
      in
        filterNull self;
    };
  };
}
