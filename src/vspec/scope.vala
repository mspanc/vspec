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
  public class Scope : Object {
    private GenericArray<GenericArray<BeforeFuncRef>> before_each_funcs = new GenericArray<GenericArray<BeforeFuncRef>>();
    private GenericArray<GenericArray<AfterFuncRef>>  after_each_funcs  = new GenericArray<GenericArray<AfterFuncRef>>();
    private GenericArray<GenericArray<CaseFuncRef>>   case_funcs        = new GenericArray<GenericArray<CaseFuncRef>>();
    private GenericArray<GenericArray<LetFuncRef>>    let_funcs         = new GenericArray<GenericArray<LetFuncRef>>();
    private GenericArray<string>                      names             = new GenericArray<string>();
    private GenericArray<bool>                        pendings          = new GenericArray<bool>();


    construct {
      this.before_each_funcs.add(new GenericArray<BeforeFuncRef>());
      this.after_each_funcs.add(new GenericArray<AfterFuncRef>());
      this.case_funcs.add(new GenericArray<CaseFuncRef>());
      this.let_funcs.add(new GenericArray<LetFuncRef>());
    }


    public void push_before_each_func(owned BeforeFunc cb) {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Pushing: before_each ($(Logger.pointer((void *)cb)))");
      this.before_each_funcs[this.before_each_funcs.length -1].add(new BeforeFuncRef((owned) cb));
    }


    public void push_after_each_func(owned AfterFunc cb) {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Pushing: after_each ($(Logger.pointer((void *)cb)))");
      this.after_each_funcs[this.after_each_funcs.length -1].insert(0, new AfterFuncRef((owned) cb));
    }


    public void push_let_func(string name, owned LetFunc cb) {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Pushing: let $(name) ($(Logger.pointer((void *)cb)))");
      this.let_funcs[this.let_funcs.length -1].add(new LetFuncRef(name, (owned) cb));
    }


    public LetFunc find_let_func(string name) throws LetError {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Finding: let $(name)");
      LetFunc? result = null;

      for(var i = this.let_funcs.length -1; i >= 0; i--) {
        this.let_funcs[i].foreach((func_ref) => {
          if(func_ref.name == name) {
            Logger.debug(@"[VSpec.Spec $(get_depth())] Finding: let $(name) found ($(Logger.pointer((void *)func_ref.cb_ref)))");
            result = (owned) func_ref.cb_ref;
          }
        });
      }

      if(result == null) {
        throw new LetError.NOT_FOUND(@"There's no such lazy-load variable as \"$name\", ensure that let(\"$name\", () => { ... }) was called in this or any of parent contexts.");

      } else {
        return (!) (owned) result;
      }
    }


    public void push_case_func(string name, owned CaseFunc cb, bool pending) {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Pushing: it $(name) ($(Logger.pointer((void *)cb))), pending = $pending");

      bool pending_real = false;
      if(pending == true) {
        pending_real = true;

      } else {
        this.pendings.foreach((depth_pending) => {
          if(depth_pending) {
            pending_real = true;
          }
        });
      }

      this.case_funcs[this.case_funcs.length -1].add(new CaseFuncRef(name, (owned) cb, pending_real));
    }


    public void call_before_each_funcs() throws LetError {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: before_each");
      LetError? error = null;

      this.before_each_funcs.foreach((func_list) => {
        func_list.foreach((func_ref) => {
          Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: before_each ($(Logger.pointer((void *)func_ref.cb_ref)))");

          try {
            func_ref.cb_ref();

          } catch(LetError e) {
            error = e;
          }
        });
      });

      if(error != null) {
        throw error;
      }
    }


    public void call_after_each_funcs() throws LetError {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: after_each");
      LetError? error = null;

      this.after_each_funcs.foreach((func_list) => {
        func_list.foreach((func_ref) => {
          Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: after_each ($(Logger.pointer((void *)func_ref.cb_ref)))");
          try {
            func_ref.cb_ref();

          } catch(LetError e) {
            error = e;
          }
        });
      });

      if(error != null) {
        throw error;
      }
    }


    public void call_case_funcs() {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: case");
      this.case_funcs[this.case_funcs.length -1].foreach((func_ref) => {
        if(func_ref.pending) {
          Logger.debug(@"[VSpec.Spec $(get_depth())] Call pending: it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
          Report.log_pending(func_ref.name, (!) this);

        } else {
          try {
            Logger.debug(@"[VSpec.Spec $(get_depth())] Calling: it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
            func_ref.cb_ref();
            Logger.debug(@"[VSpec.Spec $(get_depth())] Call OK: it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
            Report.log_ok(func_ref.name, (!) this);

          } catch(MatchError e) {
            Logger.debug(@"[VSpec.Spec $(get_depth())] Match Error (LetError): it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
            Report.log_error(func_ref.name, (!) this, @"Expectation failed: $(e.message)");

          } catch(LetError e) {
            Logger.debug(@"[VSpec.Spec $(get_depth())] Call Error (LetError): it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
            Report.log_error(func_ref.name, (!) this, @"LetError in it(): $(e.message)");

          } catch(Error e) {
            Logger.debug(@"[VSpec.Spec $(get_depth())] Call Error (other Error): it $(func_ref.name) ($(Logger.pointer((void *)func_ref.cb_ref)))");
            Report.log_error(func_ref.name, (!) this, @"Error $(e.domain.to_string()) $(e.code): $(e.message)");
          }
        }
      });
    }


    public void increase_depth(string name, bool pending) {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Increasing depth, pending = $pending");
      this.before_each_funcs.add(new GenericArray<BeforeFuncRef>());
      this.after_each_funcs.add(new GenericArray<AfterFuncRef>());
      this.case_funcs.add(new GenericArray<CaseFuncRef>());
      this.names.add(name);
      this.pendings.add(pending);
    }


    public void decrease_depth() {
      Logger.debug(@"[VSpec.Spec $(get_depth())] Decreasing depth");
      this.before_each_funcs.remove_index(this.before_each_funcs.length -1);
      this.after_each_funcs.remove_index(this.after_each_funcs.length -1);
      this.case_funcs.remove_index(this.case_funcs.length -1);
      if(this.pendings.length != 0) {
        this.pendings.remove_index(this.pendings.length -1);
      }
      if(this.names.length != 0) {
        this.names.remove_index(this.names.length -1);
      }
    }


    public uint get_depth() {
      return this.before_each_funcs.length -1;
    }


    public GenericArray<string> get_names() {
      return this.names;
    }


    private class BeforeFuncRef : Object {
      public BeforeFunc cb_ref;

      public BeforeFuncRef(owned BeforeFunc cb) {
        this.cb_ref = (owned) cb;
      }
    }


    private class AfterFuncRef : Object {
      public AfterFunc cb_ref;

      public AfterFuncRef(owned AfterFunc cb) {
        this.cb_ref = (owned) cb;
      }
    }


    private class CaseFuncRef : Object {
      public string name    { get; construct set; }
      public bool   pending { get; construct set; }
      public CaseFunc cb_ref;

      public CaseFuncRef(string name, owned CaseFunc cb, bool pending) {
        this.name = name;
        this.pending = pending;
        this.cb_ref = (owned) cb;
      }
    }


    private class LetFuncRef : Object {
      public string  name    { get; construct set; }
      public LetFunc cb_ref;

      public LetFuncRef(string name, owned LetFunc cb) {
        this.name = name;
        this.cb_ref = (owned) cb;
      }
    }
  }
}
