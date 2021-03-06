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
  public errordomain LetError {
    NOT_FOUND,
    TYPE_MISMATCH,
    TYPE_NOT_SUPPORTED
  }

  public errordomain MatchError {
    MISMATCH
  }

  private static GenericArray<Type>? suites           = null;
  private static BeforeFunc?         before_all_func  = null;
  private static AfterFunc?          after_all_func   = null;
  private static Scope?              scope            = null;

  public static bool verbose = false;

  public delegate void AfterFunc() throws LetError;
  public delegate void BeforeFunc() throws LetError;
  public delegate void ScopeFunc() throws LetError;
  public delegate void CaseFunc() throws Error;
  public delegate Value? LetFunc() throws LetError;
  public delegate bool MatchFunc(Value value, bool positive);

  public static void before_all(owned BeforeFunc cb) {
    before_all_func = (owned) cb;
  }


  public static void after_all(owned AfterFunc cb) {
    after_all_func = (owned) cb;
  }


  public static void before_each(owned BeforeFunc cb) {
    initialize_scope();
    ((!) scope).push_before_each_func((owned) cb);
  }


  public static void after_each(owned AfterFunc cb) {
    initialize_scope();
    ((!) scope).push_after_each_func((owned) cb);
  }


  private static void initialize_scope() {
    if(scope == null) {
      scope = new Scope();
    }
  }


  public static void add(Type suite_type) {
    initialize_suites();

    if(suite_type.is_a(typeof(Spec))) {
      ((!) suites).add(suite_type);

    } else {
      critical(@"Unable to add suite of type $(suite_type.name()): it is not derived from VSpec.Spec class");
      assert_not_reached();
    }
  }


  private static void initialize_suites() {
    if(suites == null) {
      suites = new GenericArray<Type>();
    }
  }


  private static void initialize_output() {
    Log.set_handler(null, LogLevelFlags.LEVEL_CRITICAL | LogLevelFlags.LEVEL_WARNING | LogLevelFlags.LEVEL_MESSAGE | LogLevelFlags.LEVEL_INFO | LogLevelFlags.LEVEL_DEBUG | LogLevelFlags.FLAG_FATAL | LogLevelFlags.FLAG_RECURSION, on_log_message);
  }


  private static void on_log_message(string? log_domain, LogLevelFlags log_level, string message) {
    if(verbose) {
      stderr.printf("%s\n", message);
      stderr.flush();

    } else {
      if((LogLevelFlags.LEVEL_ERROR in log_level) || (LogLevelFlags.LEVEL_CRITICAL in log_level)) {
        stderr.printf("%s\n", message);
        stderr.flush();
      }
    }
  }


  public static int run() {
    initialize_suites();
    initialize_scope();
    initialize_output();

    if(before_all_func != null) {
      try {
        before_all_func();

      } catch(LetError e) {
        Report.log_error("(root)", (!) scope, @"LetError in VSpec.before_all(): $(e.message)");
      }
    }

    ((!) suites).foreach((suite_type) => {
      Spec? suite = Object.new(suite_type) as Spec;

      if(suite != null) {
        ((!) scope).increase_depth(suite_type.name(), false);
        ((!) suite).run((!) scope);
        ((!) scope).decrease_depth();

      } else {
        critical(@"Unable to initialize object of type $(suite_type.name())");
        assert_not_reached();
      }
    });

    if(after_all_func != null) {
      try {
        after_all_func();

      } catch(LetError e) {
        Report.log_error("(root)", (!) scope, @"LetError in VSpec.after_all(): $(e.message)");
      }
    }

    Report.print_report();

    if(Report.errors_count != 0) {
      return 1;

    } else {
      return 0;
    }
  }
}
