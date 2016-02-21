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
  public class Logger : Object {
    public static void debug(string msg) {
      if(Environment.get_variable("VSPEC_DEBUG") != null) {
        stderr.printf("%s\n", msg);
        stderr.flush();
      }
    }


    public static string pointer(void* ptr) {
      return "%p".printf(ptr);
    }
  }
}
