namespace VSpec {
  public abstract class Spec : Object {
    private Context root_context = new Context(null, null);

    public abstract void define();


    public void run() {
      define();
    }


    protected void describe(string name, Context.ContextNestedFunc nested_cb) {
      this.root_context.context(name, nested_cb);
    }
  }
}
