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
     * This matcher tests if passed Object is of certain type.
     */
    public class be_instance_of : Matcher {
      protected override bool message_contains_value_right { get { return false; } }

      public override void match() throws MatchError {
        if(this.value_left == null || this.value_right == null) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with null values, $(get_values_message()).");
        }

        if(!((!)this.value_left).holds(typeof(Object))) {
          throw new MatchError.MISMATCH(@"Unable to use eq matcher with non-Object left value, $(get_values_message()).");
        }

        if(!((!)this.value_right).holds(typeof(void *))) {
          throw new MatchError.MISMATCH(@"Unable to use eq matcher with non-Type right value, $(get_values_message()).");
        }

        if((((!)this.value_left).get_object().get_type().is_a(get_tested_type())) != positive) {
          throw new MatchError.MISMATCH(get_mismatch_message());
        }
      }


      private Type get_tested_type() {
        return (Type) ((!)this.value_right).get_pointer();
      }


      protected override string get_positive_message() {
        return @"Expected value to be of type $(get_tested_type().name())";
      }


      protected override string get_negative_message() {
        return @"Expected value to be not of type $(get_tested_type().name())";
      }
    }
  }
}
