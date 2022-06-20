{lib}: {
  testAlertCondition = {
    expr = {
      basic = (lib.alertCondition.new {}).__unpop__;
      advanced =
        (lib.alertCondition.new {
          evaluatorType = "within_range";
          evaluatorParams = [1234 4321];
          operatorType = "or";
          reducerType = "diff";
          queryRefId = "B";
          queryTimeStart = "15m";
          queryTimeEnd = "now-1h";
        })
        .__unpop__;
    };
    expected = lib.loadTestOutput "alert";
  };
}
