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
 * @internal
 * @description Encompasses functionality relating to building a WHERE clause for SOQL queries.
 */
public with sharing class ASB_Filter implements ASB_Clause {
  private final ASB_FilterExpression expression;

  /**
   * @internal
   * @description Constructs a new ASB_Filter with the given expression.
   * @param expression The expression to use for the WHERE clause.
   */
  public ASB_Filter(ASB_FilterExpression expression) {
    this.expression = expression;
  }

  /**
   * @internal
   * @description Returns the WHERE clause as a query string.
   * @param ctx The bind context for query string generation.
   * @return String The WHERE clause as a string.
   */
  public String clauseString(ASB_BindContext ctx) {
    String queryString = this.expression.filterString(ctx);
    if (this.expression instanceof ASB_FilterLogicalGroup) {
      queryString = queryString.removeStart('(').removeEnd(')');
    }
    return 'WHERE ' + queryString;
  }
}
