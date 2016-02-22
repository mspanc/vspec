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
  public abstract class Matcher : Object {
    public Value? value_left  = null;
    public Value? value_right = null;
    public bool   positive    = true;

    protected abstract bool message_contains_value_right { get; }

    public abstract void match() throws MatchError;
    public abstract string get_positive_message();
    protected abstract string get_negative_message();


    protected string get_mismatch_message() {
      if(this.positive) {
        return @"$(get_positive_message()), $(get_values_message()).";

      } else {
        return @"$(get_negative_message()), $(get_values_message()).";
      }
    }

    protected string get_values_message() {
      if(this.message_contains_value_right) {
        return @"$(value_to_string(this.value_left)) and $(value_to_string(this.value_right)) given";

      } else {
        return @"$(value_to_string(this.value_left)) given";
      }
    }


    protected string value_to_string(Value? value) {
      if(value == null) {
        return "(null)";

      } else if(((!)value).holds(typeof(string))) {
        return @"(string) \"$(((!)value).get_string())\"";

      } else if(((!)value).holds(typeof(bool))) {
        return ((!)value).get_boolean() ? "(boolean) true" : "(boolean) false";

      } else if(((!)value).holds(typeof(char))) {
        return @"(char) $(((!)value).get_char())";

      } else if(((!)value).holds(typeof(int8))) {
        return @"(schar) $(((!)value).get_schar())";

      } else if(((!)value).holds(typeof(uchar))) {
        return @"(uchar) $(((!)value).get_uchar())";

      } else if(((!)value).holds(typeof(int))) {
        return @"(int16) $(((!)value).get_int())";

      } else if(((!)value).holds(typeof(uint))) {
        return @"(uint16) $(((!)value).get_uint())";

      } else if(((!)value).holds(typeof(long))) {
        return @"(int32) $(((!)value).get_long())";

      } else if(((!)value).holds(typeof(ulong))) {
        return @"(uuint32) $(((!)value).get_ulong())";

      } else if(((!)value).holds(typeof(int64))) {
        return @"(int64) $(((!)value).get_int64())";

      } else if(((!)value).holds(typeof(uint64))) {
        return @"(uint64) $(((!)value).get_uint64())";

      } else if(((!)value).holds(typeof(float))) {
        return @"(float) $(((!)value).get_float())";

      } else if(((!)value).holds(typeof(double))) {
        return @"(double) $(((!)value).get_double())";

      } else if(((!)value).holds(typeof(Object))) {
        return @"(object) $(((!)value).get_object().get_type().name()) $("%p".printf(((!)value).get_object()))";

      } else if(((!)value).holds(typeof(void *))) {
        return @"(pointer) $("%p".printf(((!)value).get_pointer()))";

      } else {
        critical(@"Unable to print value: Unknown value type $(((!)value).type().name())");
        assert_not_reached();
      }
    }
  }
}
