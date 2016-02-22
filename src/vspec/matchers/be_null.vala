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
  namespace Matchers {
    /*
     * This matcher tests if passed value is a null pointer.
     */
    public class be_null : Matcher {
      protected override bool message_contains_value_right { get { return false; } }

      public override void match() throws MatchError {
        if((this.value_left == null) != positive) {
          throw new MatchError.MISMATCH(get_mismatch_message());
        }
      }


      protected override string get_positive_message() {
        return "Expected value to be null";
      }


      protected override string get_negative_message() {
        return "Expected value to be not null";
      }
    }
  }
}
