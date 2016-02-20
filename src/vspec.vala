namespace VSpec {
  private static GenericArray<Type>? suites = null;
  public static void add(Type suite_type) {
    initialize_suites();

    if(suite_type.is_a(typeof(Suite))) {
      ((!) suites).add(suite_type);

    } else {
      critical(@"Unable to add suite of type $(suite_type.name()): it is not derived from VSpec.Suite class");
      assert_not_reached();
    }
  }


  private static void initialize_suites() {
    if(suites == null) {
      suites = new GenericArray<Type>();
    }
  }


  public static int run() {
    initialize_suites();

    ((!) suites).foreach((suite_type) => {
      Suite? suite = Object.new(suite_type) as Suite;

      if(suite != null) {
        ((!) suite).run();

      } else {
        critical(@"Unable to initialize object of type $(suite_type.name())");
        assert_not_reached();
      }
    });

    return 0; // TODO
  }
}
