{
  inputs.yants.url = "github:divnix/yants";
  inputs.nixlib.url = "github:nix-community/nixpkgs.lib";
  inputs.POP.url = "github:divnix/POP/visibility";

  # Development Dependencies
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.grafonnet = {
    url = "github:grafana/grafonnet-lib";
    flake = false;
  };

  outputs = {
    self,
    yants,
    nixlib,
    POP,
    nixpkgs,
    ...
  }: let
    lib =
      POP.lib
      // nixlib.lib
      // self.lib
      // (import ./internal {inherit lib;});

    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin"];
    # Pass this flake(self) as "grafonnix"
    polyfillInputs = self.inputs // {grafonnix = self;};
    polyfillOutput = loc:
      nixlib.lib.genAttrs supportedSystems (system:
        import loc {
          inherit system;
          inputs = polyfillInputs;
        });
  in {
    lib = {
      alertlist = import ./grafonnix/alertlist.nix {inherit lib;};
      alertCondition = import ./grafonnix/alert_condition.nix {inherit lib;};
      annotation = import ./grafonnix/annotation.nix {inherit lib;};
      barGuagePanel = import ./grafonnix/bar_gauge_panel.nix {inherit lib;};
      cloudmonitoring = import ./grafonnix/cloudmonitoring.nix {inherit lib;};
      cloudwatch = import ./grafonnix/cloudwatch.nix {inherit lib;};
      dashboard = import ./grafonnix/dashboard.nix {inherit lib;};
      dashlist = import ./grafonnix/dashlist.nix {inherit lib;};
      elasticsearch = import ./grafonnix/elasticsearch.nix {inherit lib;};
      gaugePanel = import ./grafonnix/gauge_panel.nix {inherit lib;};
      graphite = import ./grafonnix/graphite.nix {inherit lib;};
      graphPanel = import ./grafonnix/graph_panel.nix {inherit lib;};
      heatmapPanel = import ./grafonnix/heatmap_panel.nix {inherit lib;};
      influxdb = import ./grafonnix/influxdb.nix {inherit lib;};
      link = import ./grafonnix/link.nix {inherit lib;};
      logPanel = import ./grafonnix/log_panel.nix {inherit lib;};
      loki = import ./grafonnix/loki.nix {inherit lib;};
      pieChartPanel = import ./grafonnix/pie_chart_panel.nix {inherit lib;};
      pluginlist = import ./grafonnix/pluginlist.nix {inherit lib;};
      prometheus = import ./grafonnix/prometheus.nix {inherit lib;};
      row = import ./grafonnix/row.nix {inherit lib;};
      singlestat = import ./grafonnix/singlestat.nix {inherit lib;};
      sql = import ./grafonnix/sql.nix {inherit lib;};
      statPanel = import ./grafonnix/stat_panel.nix {inherit lib;};
      tablePanel = import ./grafonnix/table_panel.nix {inherit lib;};
      template = import ./grafonnix/template.nix {inherit lib;};
      text = import ./grafonnix/text.nix {inherit lib;};
      timepicker = import ./grafonnix/timepicker.nix {inherit lib;};
      transformation = import ./grafonnix/transformation.nix {inherit lib;};
    };
    checks = polyfillOutput ./checks;
    formatter = nixlib.lib.genAttrs supportedSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
