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
  public class Context : Object {
    private static const string COLOR_CODE_OK = "\033[1;32m";
    private static const string COLOR_CODE_PENDING = "\033[1;33m";
    private static const string COLOR_CODE_ERROR = "\033[1;31m";
    private static const string COLOR_CODE_CLOSE = "\033[0m";

    public      bool      pending  { get; construct set; default = false; }
    public      string?   name     { get; construct set; }
    public weak Context?  parent   { get; construct set; default = null; }

    private weak BeforeFunc? before_func = null;
    private weak AfterFunc?  after_func = null;


    public Context(string? name, Context? parent, bool pending = false) {
      Object(name: name, parent: parent, pending: pending);
    }


    public delegate void ContextNestedFunc(Context context);
    public void context(string name, ContextNestedFunc cb) {
      if(this.pending) {
        xcontext(name, cb);
      } else {

        var child = new Context(name, this);

        call_before();

        cb(child);

        call_after();
      }
    }


    public void xcontext(string name, ContextNestedFunc cb) {
      var child = new Context(name, this, true);

      cb(child);
    }


    public delegate void TestCaseFunc(Context context) throws Error;
    public void it(string name, TestCaseFunc cb) {
      if(this.pending) {
        xit(name, cb);

      } else {
        call_before();

        try {
          cb(this);
          report_ok();

        } catch(Error e) {
          report_error(); // TODO add path & details
        }

        call_after();
      }
    }


    public void xit(string name, TestCaseFunc cb) {
      report_pending();
    }


    private void report_error() {
      stderr.printf("%s.%s", COLOR_CODE_ERROR, COLOR_CODE_CLOSE);
    }


    private void report_ok() {
      stderr.printf("%s.%s", COLOR_CODE_OK, COLOR_CODE_CLOSE);
    }


    private void report_pending() {
      stderr.printf("%s.%s", COLOR_CODE_ERROR, COLOR_CODE_CLOSE);
    }


    public delegate void BeforeFunc();
    public void before(BeforeFunc cb) {
      this.before_func = cb;
    }


    public delegate void AfterFunc();
    public void after(AfterFunc cb) {
      this.after_func = cb;
    }


    private void call_before() {
      if(this.before_func != null) {
        this.before_func();
      }
    }


    private void call_after() {
      if(this.after_func != null) {
        this.after_func();
      }
    }
  }
}
