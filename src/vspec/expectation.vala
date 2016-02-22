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
  public class Expectation : Object {
    public Value value_left { get; construct set; }


    public Expectation(Value value_left) {
      Object(value_left: value_left);
    }


    public Match to<matcher_type>(Value value_right) throws MatchError {
      return match<matcher_type>(value_right, true);
    }


    public Match not_to<matcher_type>(Value value_right) throws MatchError {
      return match<matcher_type>(value_right, false);
    }


    public Match match<matcher_type>(Value value_right, bool positive) throws MatchError {
      Matcher? matcher = Object.new(typeof(matcher_type), "value_left", this.value_left, "value_right", value_right, "positive", positive) as Matcher;

      if(matcher != null) {
        return new Match((!) matcher);

      } else {
        critical(@"Unable to initialize instance of matcher type $(typeof(matcher_type).name())");
        assert_not_reached();
      }
    }
  }
}
