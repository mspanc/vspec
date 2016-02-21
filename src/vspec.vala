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
  private static GenericArray<Type>? suites          = null;
  private static BeforeAllFunc?      before_all_func = null;
  private static AfterAllFunc?       after_all_func  = null;


  public delegate void BeforeAllFunc();
  public static void before_all(BeforeAllFunc cb) {
    before_all_func = cb;
  }


  public delegate void AfterAllFunc();
  public static void after_all(AfterAllFunc cb) {
    after_all_func = cb;
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


  public static int run() {
    initialize_suites();

    if(before_all_func != null) {
      before_all_func();
    }

    ((!) suites).foreach((suite_type) => {
      Spec? suite = Object.new(suite_type) as Spec;

      if(suite != null) {
        ((!) suite).run();

        stdout.printf("\n");

      } else {
        critical(@"Unable to initialize object of type $(suite_type.name())");
        assert_not_reached();
      }
    });

    if(after_all_func != null) {
      after_all_func();
    }

    return 0; // TODO
  }
}
