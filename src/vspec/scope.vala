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
    public uint depth { get; private set; default = 0; }

    private List<BeforeFuncRef> before_each_funcs = new List<BeforeFuncRef>();
    private List<AfterFuncRef>  after_each_funcs  = new List<AfterFuncRef>();
    private List<CaseFuncRef>   case_funcs        = new List<CaseFuncRef>();


    public void push_before_each_func(owned BeforeFunc cb) {
      this.before_each_funcs.append(new BeforeFuncRef(this.depth, (owned) cb));
    }


    public void push_after_each_func(owned AfterFunc cb) {
      this.after_each_funcs.prepend(new AfterFuncRef(this.depth, (owned) cb));
    }


    public void push_case_func(string name, owned CaseFunc cb) {
      this.case_funcs.append(new CaseFuncRef(name, this.depth, (owned) cb));
    }


    public void call_before_each_funcs() {
      foreach(var func_ref in this.before_each_funcs) {
        if(func_ref.depth <= this.depth) {
          func_ref.call();
        }
      }
    }


    public void call_after_each_funcs() {
      foreach(var func_ref in this.after_each_funcs) {
        if(func_ref.depth <= this.depth) {
          func_ref.call();
        }
      }
    }


    public void call_case_funcs() {
      foreach(var func_ref in this.case_funcs) {
        if(func_ref.depth <= this.depth) {
          try {
            debug(@"[VSpec.Spec] Calling: it $(func_ref.name)");
            func_ref.call();
            debug(@"[VSpec.Spec] Call OK: it $(func_ref.name)");
            Report.log_ok((!) this);

          } catch(Error e) {
            debug(@"[VSpec.Spec] Call error: it $(func_ref.name)");
            Report.log_error((!) this); // TODO add detailed information
          }
        }
      }
    }


    public void increase_depth() {
      this.depth++;
    }


    public void decrease_depth() {
      // TODO remove obsolete before/after callbacks
      this.depth--;
    }


    private class BeforeFuncRef : Object {
      public uint depth { get; construct set; }
      private BeforeFunc cb_ref;

      public BeforeFuncRef(uint depth, owned BeforeFunc cb) {
        this.depth = depth;
        this.cb_ref = (owned) cb;
      }


      public void call() {
        this.cb_ref();
      }
    }


    private class AfterFuncRef : Object {
      public uint depth { get; construct set; }
      private AfterFunc cb_ref;

      public AfterFuncRef(uint depth, owned AfterFunc cb) {
        this.depth = depth;
        this.cb_ref = (owned) cb;
      }


      public void call() {
        this.cb_ref();
      }
    }


    private class CaseFuncRef : Object {
      public string name { get; construct set; }
      public uint depth { get; construct set; }
      private CaseFunc cb_ref;

      public CaseFuncRef(string name, uint depth, owned CaseFunc cb) {
        this.name = name;
        this.depth = depth;
        this.cb_ref = (owned) cb;
      }


      public void call() throws Error {
        this.cb_ref();
      }
    }
  }
}
