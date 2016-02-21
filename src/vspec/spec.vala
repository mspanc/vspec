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


    protected void before_each(owned BeforeFunc cb)
    requires(this.scope != null) {
      ((!) this.scope).push_before_each_func((owned) cb);
    }


    protected void after_each(owned AfterFunc cb)
    requires(this.scope != null) {
      ((!) this.scope).push_after_each_func((owned) cb);
    }


    protected void describe(string name, owned ScopeFunc cb) {
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


    protected void context(string name, owned ScopeFunc cb) {
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


    protected void it(string name, owned CaseFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: it $name");

      ((!) this.scope).push_case_func(name, (owned) cb, false);

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: it $name");
    }


    protected void xdescribe(string name, owned ScopeFunc cb) {
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


    protected void xcontext(string name, owned ScopeFunc cb) {
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


    protected void xit(string name, owned CaseFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Entering: xit $name");

      ((!) this.scope).push_case_func(name, (owned) cb, true);

      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Exiting: xit $name");
    }


    protected void let(string name, owned LetFunc cb) {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Letting: let $name");

      ((!) this.scope).push_let_func(name, (owned) cb);
    }


    protected LetFunc pick(string name) throws LetError {
      Logger.debug(@"[VSpec.Spec $(((!) this.scope).get_depth())] Picking: let $name");

      return ((!) this.scope).find_let_func(name);
    }


    protected void @set(string name, owned LetFunc cb) {
      let(name, (owned) cb);
    }


    protected LetFunc @get(string name) throws LetError {
      return pick(name);
    }
  }
}
