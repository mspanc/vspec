/*
 * VSpec - RSpec-like testing framework for the Vala Language.
 * Copyright (C) 2016  Marcin Lewandowski <marcin@saepia.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace VSpec {
  public abstract class Spec : Object {
    public abstract void define();

    private Scope?  scope = null;


    public void run(Scope scope) {
      this.scope = scope;
      define();
    }


    public void before_each(owned BeforeFunc cb)
    requires(this.scope != null) {
      ((!) this.scope).push_before_each_func((owned) cb);
    }


    public void after_each(owned AfterFunc cb)
    requires(this.scope != null) {
      ((!) this.scope).push_after_each_func((owned) cb);
    }


    public void describe(string name, owned ScopeFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: describe $name");

      ((!) this.scope).increase_depth(name, false);
      try {
        cb();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, "@LetError in describe(): $(e.message)");
      }

      try {
        ((!) this.scope).call_before_each_funcs();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, @"LetError in before_each(): $(e.message)");
      }

      ((!) this.scope).call_case_funcs();

      try {
        ((!) this.scope).call_after_each_funcs();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, @"LetError in after_each(): $(e.message)");
      }

      ((!) this.scope).decrease_depth();

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: describe $name");
    }


    public void context(string name, owned ScopeFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: context $name");

      ((!) this.scope).increase_depth(name, false);
      try {
        cb();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, "@LetError in context(): $(e.message)");
      }

      try {
        ((!) this.scope).call_before_each_funcs();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, @"LetError in before_each(): $(e.message)");
      }

      ((!) this.scope).call_case_funcs();

      try {
        ((!) this.scope).call_after_each_funcs();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, @"LetError in after_each(): $(e.message)");
      }

      ((!) this.scope).decrease_depth();

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: context $name");
    }


    public void it(string name, owned CaseFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: it $name");

      ((!) this.scope).push_case_func(name, (owned) cb, false);

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: it $name");
    }


    public void xdescribe(string name, owned ScopeFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: xdescribe $name");

      ((!) this.scope).increase_depth(name, true);
      try {
        cb();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, "@LetError in xdescribe(): $(e.message)");
      }

      ((!) this.scope).call_case_funcs();

      ((!) this.scope).decrease_depth();

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: xdescribe $name");
    }


    public void xcontext(string name, owned ScopeFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: xcontext $name");

      ((!) this.scope).increase_depth(name, true);
      try {
        cb();
      } catch(LetError e) {
        Report.log_error(name, (!) this.scope, "@LetError in xcontext(): $(e.message)");
      }

      ((!) this.scope).call_case_funcs();

      ((!) this.scope).decrease_depth();

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: xcontext $name");
    }


    public void xit(string name, owned CaseFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: xit $name");

      ((!) this.scope).push_case_func(name, (owned) cb, true);

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: xit $name");
    }


    public void let(string name, owned LetFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Letting: let $name");

      ((!) this.scope).push_let_func(name, (owned) cb);
    }


    public Value? pick(string name) throws LetError {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Picking: $name");

      return ((!) this.scope).find_let_func(name)();
    }


    public ExpectedType pick_as<ExpectedType>(string name) throws LetError {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Picking as $(typeof(ExpectedType).name()): $name");

      Value? value = ((!) this.scope).find_let_func(name)();
      if(value != null) {
        if(((!) value).holds(typeof(ExpectedType))) {
          if(((!)value).holds(typeof(string))) {
            return (ExpectedType) (((!)value).get_string());

          } else if(((!)value).holds(typeof(bool))) {
            return (ExpectedType) (((!)value).get_boolean());

          } else if(((!)value).holds(typeof(char))) {
            return (ExpectedType) (((!)value).get_char());

          } else if(((!)value).holds(typeof(int8))) {
            return (ExpectedType) (((!)value).get_schar());

          } else if(((!)value).holds(typeof(uchar))) {
            return (ExpectedType) (((!)value).get_uchar());

          } else if(((!)value).holds(typeof(int))) {
            return (ExpectedType) (((!)value).get_int());

          } else if(((!)value).holds(typeof(uint))) {
            return (ExpectedType) (((!)value).get_uint());

          } else if(((!)value).holds(typeof(long))) {
            return (ExpectedType) (((!)value).get_long());

          } else if(((!)value).holds(typeof(ulong))) {
            return (ExpectedType) (((!)value).get_ulong());

          } else if(((!)value).holds(typeof(int64))) {
            return (ExpectedType) (((!)value).get_int64());

          } else if(((!)value).holds(typeof(uint64))) {
            return (ExpectedType) (((!)value).get_uint64());
/*
          // FIXME throws C compiler error
          } else if(((!)value).holds(typeof(float))) {
            return (ExpectedType) (((!)value).get_float());

          } else if(((!)value).holds(typeof(double))) {
            return (ExpectedType) (((!)value).get_double());
*/
          } else if(((!)value).holds(typeof(Object))) {
            return (ExpectedType) (((!)value).get_object());

          } else if(((!)value).holds(typeof(void *))) {
            return (ExpectedType) (((!)value).get_pointer());

          } else {
            throw new LetError.TYPE_NOT_SUPPORTED(@"Unable to call pick_as: Type $(typeof(ExpectedType).name()) is not supported");
          }

        } else {
          throw new LetError.TYPE_MISMATCH(@"Unable to call pick_as: Requested type $(typeof(ExpectedType).name()) but value is of type $(((!) value).type().name())");
        }

      } else {
        assert_not_reached();
      }
    }


    public void @set(string name, owned LetFunc cb) {
      let(name, (owned) cb);
    }


    public Value? @get(string name) throws LetError {
      return pick(name);
    }


    public Expectation expect(Value? value_left) {
      return new Expectation(value_left);
    }
  }
}
