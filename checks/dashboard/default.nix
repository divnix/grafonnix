{lib}: {
  testDashboardAdds = {
    expr = import ./adds.nix {inherit lib;};
    expected = lib.loadTestFile "dashboards/adds_compiled.json";
  };
}
