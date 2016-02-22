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
     * This matcher tests equality of two values.
     *
     * It tests whether pointers to the memory of passed values are equal,
     * not its values.
     *
     * {{{
     * var obj = new Object();
     * expect(obj).to<be>(obj);
     * }}}
     */
    public class be : Matcher {
      protected override bool message_contains_value_right { get { return true; } }

      public override void match() throws MatchError {
        if(this.value_left == null || this.value_right == null) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with null values, $(get_values_message()).");
        }

        if(((!)this.value_left).type() != ((!)this.value_right).type()) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with two different value types, $(get_values_message()).");
        }

        void* value_left_ptr = null;
        void* value_right_ptr = null;

        if(((!)this.value_left).holds(typeof(string))) {
          value_left_ptr = ((!)this.value_left).get_string();
          value_right_ptr = ((!)this.value_right).get_string();

        } else if(((!)this.value_left).holds(typeof(bool))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(char))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(int8))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(uchar))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(int))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(uint))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(long))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(ulong))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(int64))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(uint64))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(float))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(double))) {
          throw new MatchError.MISMATCH(@"Unable to use be matcher with non-reference value types, $(get_values_message()).");

        } else if(((!)this.value_left).holds(typeof(Object))) {
          value_left_ptr = ((!)this.value_left).get_object();
          value_right_ptr = ((!)this.value_right).get_object();

        } else if(((!)this.value_left).holds(typeof(void *))) {
          value_left_ptr = ((!)this.value_left).get_pointer();
          value_right_ptr = ((!)this.value_right).get_pointer();

        } else {
          critical(@"Unable to compare value: Unknown value type $(((!)this.value_left).type().name()) or $(((!)this.value_right).type().name())");
          assert_not_reached();
        }

        if((value_left_ptr == value_right_ptr) != positive) {
          throw new MatchError.MISMATCH(get_mismatch_message());
        }
      }


      protected override string get_positive_message() {
        return "Expected values to be have exact reference";
      }


      protected override string get_negative_message() {
        return "Expected values to be not have exact reference";
      }
    }
  }
}
