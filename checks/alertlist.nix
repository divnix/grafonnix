{lib}: {
  testAlertlist = {
    expr = {
      basic = (lib.alertlist.new {span = 12;}).__unpop__;
      advanced =
        (lib.alertlist.new {
          title = "Alerts List";
          datasource = "$PROMETHEUS";
          description = "description";
          span = 5;
          show = "current";
          limit = 20;
          sortOrder = 2;
          stateFilter = [
            "ok"
            "pending"
          ];
          onlyAlertsOnDashboard = true;
          transparent = true;
        })
        .__unpop__;
    };
    expected = lib.loadTestOutput "alertlist";
  };
}
