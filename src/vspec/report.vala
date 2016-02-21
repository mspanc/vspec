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


    public static void log_error(Scope scope) {
      stderr.printf("%s.%s", COLOR_CODE_ERROR, COLOR_CODE_CLOSE);
    }


    public static void log_ok(Scope scope) {
      stderr.printf("%s.%s", COLOR_CODE_OK, COLOR_CODE_CLOSE);
    }


    public static void log_pending(Scope scope) {
      stderr.printf("%s.%s", COLOR_CODE_ERROR, COLOR_CODE_CLOSE);
    }

  }
}
