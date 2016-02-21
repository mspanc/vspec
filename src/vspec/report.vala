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
  public class Report : Object {
    private static const string COLOR_CODE_OK = "\033[1;32m";
    private static const string COLOR_CODE_PENDING = "\033[1;33m";
    private static const string COLOR_CODE_ERROR = "\033[1;31m";
    private static const string COLOR_CODE_CLOSE = "\033[0m";

    private static StringBuilder? errors;
    private static StringBuilder? pendings;

    public static uint64 ok_count = 0;
    public static uint64 errors_count = 0;
    public static uint64 pendings_count = 0;


    public static void log_ok(string name, Scope scope) {
      ok_count++;
      print_dot(COLOR_CODE_OK);
    }


    public static void log_error(string name, Scope scope, string reason, string message) {
      initialize_errors();
      errors_count++;
      print_dot(COLOR_CODE_ERROR);

      log_append((!) errors, name, scope, @"$(reason): $(message)");
    }


    public static void log_pending(string name, Scope scope) {
      initialize_pendings();
      pendings_count++;
      print_dot(COLOR_CODE_PENDING);

      log_append((!) pendings, name, scope, "Pending");
    }


    private static void log_append(StringBuilder builder, string name, Scope scope, string? extra = null) {
      uint indent = 0;
      uint i = 0;

      scope.get_names().foreach((depth_name) => {
        for(i = 0; i < indent; i++) {
          builder.append("  ");
        }
        builder.append(depth_name);
        builder.append("\n");

        indent++;
      });

      for(i = 0; i < indent; i++) {
        builder.append("  ");
      }
      builder.append(name);
      builder.append("\n");

      if(extra != null) {
        builder.append("\n");

        for(i = 0; i < indent; i++) {
          builder.append("  ");
        }

        builder.append((!) extra);

        builder.append("\n\n");
      }
    }


    private static void print_dot(string color_code) {
      stdout.printf("%s.%s", color_code, COLOR_CODE_CLOSE);
      stdout.flush();
    }


    public static void print_report() {
      stdout.printf("\n\n");
      stdout.printf(@"Finished: $(ok_count) OK, $(pendings_count) pending, $(errors_count) errors");

      stdout.printf("\n\n");
      print_pendings();
      print_errors();
    }


    private static void print_errors() {
      initialize_errors();
      print_log((!) errors, COLOR_CODE_ERROR);
    }


    private static void print_pendings() {
      initialize_pendings();
      print_log((!) pendings, COLOR_CODE_PENDING);
    }


    private static void print_log(StringBuilder builder, string color_code) {
      stdout.printf("%s%s%s", color_code, builder.str, COLOR_CODE_CLOSE);
      stdout.printf("\n");
      stdout.flush();
    }


    private static void initialize_errors() {
      if(errors == null) {
        errors = new StringBuilder();
      }
    }


    private static void initialize_pendings() {
      if(pendings == null) {
        pendings = new StringBuilder();
      }
    }
  }
}
