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
 * @description Handles functionality associated with a Logical Group expression (AND/OR joining).
 * @group WHERE
 * @example
 * ```
 *   ASB asb = new ASB();
 *   ASB_Expression exp1 = asb.filter().field(Account.Name).eq('acme');
 *   ASB_Expression exp2 = asb.filter().field(Account.NumberOfEmployees).gt(100);
 *   ASB_FilterLogicalGroup fieldComparison asb.filter().andGroup(exp1, exp2); // Name = 'acme' AND NumberOfEmployees > 100
 * ```
 */
public with sharing class ASB_FilterLogicalGroup implements ASB_FilterExpression {
  public static final Operator AND_OP = operator.AND_OP;
  public static final Operator OR_OP = operator.OR_OP;

  private static final Map<Operator, String> OP_STR = new Map<Operator, String>{ AND_OP => 'AND', OR_OP => 'OR' };

  private final List<ASB_FilterExpression> expressions;
  private final Operator operator;

  /**
   * @internal
   * @description constructs new `ASB_FilterExpression` with given list of expressions with the given logical operator
   */
  public ASB_FilterLogicalGroup(List<ASB_FilterExpression> expressions, Operator operator) {
    this.expressions = new List<ASB_FilterExpression>();
    for (ASB_FilterExpression ex : expressions) {
      if (ex != null) {
        this.expressions.add(ex);
      }
    }
    this.operator = operator;
  }

  /**
   * @description Returns query string and applies binds to given `ASB_BindContext`.
   * @param ASB_BindContext Bind context used for assigning bind properties.
   * @return SOQL stringified version of field expression
   */
  public String filterString(ASB_BindContext ctx) {
    List<String> parts = new List<String>();
    for (ASB_FilterExpression exp : this.expressions) {
      parts.add(exp.filterString(ctx));
    }
    return '(' + String.join(parts, ' ' + OP_STR.get(this.operator) + ' ') + ')';
  }

  public enum Operator {
    AND_OP,
    OR_OP
  }
}
