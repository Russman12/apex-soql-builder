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
 * @description Contains methods for constructing various filter elements
 * @group WHERE
 * @example
 * ```
 *   ASB asb = new ASB();
 *   ASB_FilterFactory filterFactory = asb.filter();
 * ```
 */
public with sharing class ASB_FilterFactory {
  private final Schema.SObjectType sObjType;

  public ASB_FilterFactory(Schema.SObjectType sObjType) {
    this.sObjType = sObjType;
  }

  // @start-group Returns a new ASB_FilterFieldComparison for the given field path.
  /**
   * @return ASB_FilterFieldComparison for chaining.
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_FilterFieldComparison fieldComparison asb.filter().field(Account.Name);
   * ```
   */
  public ASB_FilterFieldComparison field(Schema.SObjectField[] fieldPath) {
    return new ASB_FilterFieldComparison(fieldPath);
  }
  public ASB_FilterFieldComparison field(Schema.SObjectField field) {
    return this.field(new List<Schema.SObjectField>{ field });
  }
  public ASB_FilterFieldComparison field(Schema.SObjectField relationshipField, Schema.SObjectField parentField) {
    return this.field(new List<Schema.SObjectField>{ relationshipField, parentField });
  }
  // @end-group

  // @start-group Creates a logical grouping of expression elements joined with AND.
  /**
   * @return ASB_FilterLogicalGroup
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_Expression exp1 = asb.filter().field(Account.Name).eq('google');
   *   ASB_Expression exp2 = asb.filter().field(Account.NumberOfEmployees).gt(100);
   *   ASB_FilterLogicalGroup fieldComparison asb.filter().andGroup(exp1, exp2); // Name = 'google' AND NumberOfEmployees > 100
   * ```
   */
  public ASB_FilterLogicalGroup andGroup(ASB_FilterExpression[] expressions) {
    return new ASB_FilterLogicalGroup(expressions, ASB_FilterLogicalGroup.AND_OP);
  }
  public ASB_FilterLogicalGroup andGroup(ASB_FilterExpression exp1, ASB_FilterExpression exp2) {
    return andGroup(new List<ASB_FilterExpression>{ exp1, exp2 });
  }
  public ASB_FilterLogicalGroup andGroup(
    ASB_FilterExpression exp1,
    ASB_FilterExpression exp2,
    ASB_FilterExpression exp3
  ) {
    return andGroup(new List<ASB_FilterExpression>{ exp1, exp2, exp3 });
  }
  // @end-group

  // @start-group Creates a logical grouping of expression elements joined with OR.
  /**
   * @description Creates an OR group of WHERE clauses.
   * @return ASB_FilterLogicalGroup
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_Expression exp1 = asb.filter().field(Account.Name).eq('google');
   *   ASB_Expression exp2 = asb.filter().field(Account.NumberOfEmployees).gt(100);
   *   ASB_FilterLogicalGroup fieldComparison asb.filter().orGroup(exp1, exp2); // Name = 'google' OR NumberOfEmployees > 100
   * ```
   */
  public ASB_FilterLogicalGroup orGroup(ASB_FilterExpression[] expressions) {
    return new ASB_FilterLogicalGroup(expressions, ASB_FilterLogicalGroup.OR_OP);
  }
  public ASB_FilterLogicalGroup orGroup(ASB_FilterExpression exp1, ASB_FilterExpression exp2) {
    return orGroup(new List<ASB_FilterExpression>{ exp1, exp2 });
  }
  public ASB_FilterLogicalGroup orGroup(
    ASB_FilterExpression exp1,
    ASB_FilterExpression exp2,
    ASB_FilterExpression exp3
  ) {
    return orGroup(new List<ASB_FilterExpression>{ exp1, exp2, exp3 });
  }
  // @end-group
}
