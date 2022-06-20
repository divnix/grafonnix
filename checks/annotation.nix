{lib}: {
  testAnnotation = {
    expr = {
      def = lib.annotation.default;
      basic =
        (lib.annotation.datasource {
          name = "basicname";
          datasource = "prom";
        })
        .__unpop__;
      advanced =
        (lib.annotation.datasource {
          name = "newAdv";
          datasource = "advDS";
          expr = "advExpr";
          enable = false;
          hide = true;
          iconColor = "rgba(25, 6, 6, 2)";
          tags = ["foo"];
          type = "rows";
          builtIn = 1;
        })
        .__unpop__;
    };
    expected = lib.loadTestOutput "annotation";
  };
}
