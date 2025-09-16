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
 * @description Encompasses functionality relating to building a query filter.
 * @group WHERE
 * @example
 * ```
 *   ASB asb = new ASB();
 *   ASB_FilterExpression where = asb.filter().field(Account.Name).eq('Acme');
 *   String soql = where.clauseString(new ASB_BindContext());
 * ```
 */
public interface ASB_FilterExpression {
  /**
   * @description Returns query string and puts bindings in given bindings map
   * @param ASB_BindContext Bind context used for assigning bind properties
   */
  String filterString(ASB_BindContext ctx);
}
