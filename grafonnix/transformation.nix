{lib}: {
  /*
    *
   * @name transformation.new
   */
  new = {
    id ? "",
    options ? {},
  }:
    lib.kPop {
      id = id;
      options = options;
    };
}
