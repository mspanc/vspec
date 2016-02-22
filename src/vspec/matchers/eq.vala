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
     * It tests whether values are equal, not if pointers to the memory of passed
     * values are equal.
     *
     * {{{
     * expect(123).to<eq>(456);
     * }}}
     */
    public class eq : Matcher {
      protected override bool message_contains_value_right { get { return true; } }

      public override void match() throws MatchError {
        if(this.value_left == null || this.value_right == null) {
          throw new MatchError.MISMATCH(@"Unable to use eq matcher with null values, $(get_values_message()).");
        }

        if(((!)this.value_left).type() != ((!)this.value_right).type()) {
          throw new MatchError.MISMATCH(@"Unable to use eq matcher with two different value types, $(get_values_message()).");
        }

        if(((!)this.value_left).holds(typeof(string))) {
          if(str_equal(((!)this.value_left).get_string(), ((!)this.value_right).get_string()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(bool))) {
          if((((!)this.value_left).get_boolean() == ((!)this.value_right).get_boolean()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(char))) {
          if((((!)this.value_left).get_char() == ((!)this.value_right).get_char()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(int8))) {
          if((((!)this.value_left).get_schar() == ((!)this.value_right).get_schar()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(uchar))) {
          if((((!)this.value_left).get_uchar() == ((!)this.value_right).get_uchar()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(int))) {
          if((((!)this.value_left).get_int() == ((!)this.value_right).get_int()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(uint))) {
          if((((!)this.value_left).get_uint() == ((!)this.value_right).get_uint()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(long))) {
          if((((!)this.value_left).get_long() == ((!)this.value_right).get_long()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(ulong))) {
          if((((!)this.value_left).get_ulong() == ((!)this.value_right).get_ulong()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(int64))) {
          if((((!)this.value_left).get_int64() == ((!)this.value_right).get_int64()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(uint64))) {
          if((((!)this.value_left).get_uint64() == ((!)this.value_right).get_uint64()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(float))) {
          if((((!)this.value_left).get_float() == ((!)this.value_right).get_float()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(double))) {
          if((((!)this.value_left).get_double() == ((!)this.value_right).get_double()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else if(((!)this.value_left).holds(typeof(Object))) {
          critical(@"TODO: eq operator for objects is not yet implemented");
          assert_not_reached();

        } else if(((!)this.value_left).holds(typeof(void *))) {
          if((((!)this.value_left).get_pointer() == ((!)this.value_right).get_pointer()) != positive) {
            throw new MatchError.MISMATCH(get_mismatch_message());
          }

        } else {
          critical(@"Unable to compare value: Unknown value type $(((!)this.value_left).type().name()) or $(((!)this.value_right).type().name())");
          assert_not_reached();
        }
      }


      protected override string get_positive_message() {
        return "Expected values to be equal";
      }


      protected override string get_negative_message() {
        return "Expected values to be not equal";
      }
    }
  }
}
