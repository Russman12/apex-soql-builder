/*
Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/**
 * @description Interface that ensures that a class can be used in a SOQL query.
 * @group Clause
 */
public interface ASB_Clause {
  /**
   * @description Returns a complete clause as a string.
   * @param ctx The bind context for query string generation.
   * @return String The clause as a string.
   * @example
   * ```
   *   String clause = new ASB().selection().clauseString(new ASB_BindContext());
   * ```
   */
  String clauseString(ASB_BindContext ctx);
}
