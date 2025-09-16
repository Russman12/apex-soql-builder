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
 * @description Handles field expression operator assignment.
 * @see ASB_FilterField
 * @see ASB_FilterFactory
 * @group WHERE
 * @example
 * ```
 *   ASB asb = ASB.get();
 *   ASB_QueryBuilder builder = asb.make(Account.SObjectType)
 *     .selection(asb.selection().field(Account.Name))
 *     .filter(asb.filter().field(Account.Name).eq('acme'));
 * ```
 */
public with sharing class ASB_FilterFieldComparison {
  private final List<Schema.SObjectField> fieldPath;

  /**
   * @internal
   * @description Constructs a `ASB_FilterFieldComparison` for the given field path.
   * @param fieldPath The field path as a list.
   */
  public ASB_FilterFieldComparison(List<Schema.SObjectField> fieldPath) {
    this.fieldPath = fieldPath;
  }

  /**
   * @description Returns field expression with equals operator.
   * @param val The value to compare.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.IsActive__c).eq(true);
   * ```
   */
  public ASB_FilterField eq(Object val) {
    return makeExpression('=', val);
  }

  /**
   * @description Returns field expression with IS NULL check.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.Name).isNull();
   * ```
   */
  public ASB_FilterField isNull() {
    return eq(null);
  }

  /**
   * @description Returns field expression with not equals operator.
   * @param val The value to compare.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.Name).ne('Acme');
   * ```
   */
  public ASB_FilterField ne(Object val) {
    return makeExpression('!=', val);
  }

  /**
   * @description Returns field expression with NOT NULL check.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.Name).isNotNull();
   * ```
   */
  public ASB_FilterField notNull() {
    return ne(null);
  }

  /**
   * @description Returns field expression with greater than operator.
   * @param val The value to compare.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.NumberOfEmployees).gt(10);
   * ```
   */
  public ASB_FilterField gt(Object val) {
    return makeExpression('>', val);
  }

  /**
   * @description Returns field expression with greater than or equals operator.
   * @param val The value to compare.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.NumberOfEmployees).gte(10);
   * ```
   */
  public ASB_FilterField gte(Object val) {
    return makeExpression('>=', val);
  }

  /**
   * @description Returns field expression with less than operator.
   * @param val The value to compare.
   * @return The filter expression.
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.NumberOfEmployees).lt(10);
   * ```
   */
  public ASB_FilterField lt(Object val) {
    return makeExpression('<', val);
  }

  /**
   * @description Returns field expression with less than or equals operator.
   * @param val The value to compare.
   * @return The filter expression.
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.NumberOfEmployees).lte(10);
   * ```
   */
  public ASB_FilterField lte(Object val) {
    return makeExpression('<=', val);
  }

  /**
   * @description Returns field expression with IN operator.
   * @param vals The list of values to compare.
   * @return The filter expression.
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.Name).isIn(new List<String>{'Acme', 'Beta'});
   * ```
   */
  public ASB_FilterField isIn(List<Object> values) {
    return makeExpression('IN', values);
  }

  /**
   * @description Returns field expression with LIKE operator.
   * @param pattern The pattern to match.
   * @return ASB_FilterField
   * @example
   * ```
   *   ASB asb = new ASB();
   *   asb.filter().field(Account.Name).isLike('A%');
   * ```
   */
  public ASB_FilterField isLike(String pattern) {
    return makeExpression('LIKE', pattern);
  }

  private ASB_FilterField makeExpression(String op, Object val) {
    return new ASB_FilterField(this.fieldPath, op, val);
  }
}
