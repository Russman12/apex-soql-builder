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
 * @description Represets a field filter expression
 * @group WHERE
 * @example
 * ```
 *   ASB asb = new ASB();
 *   ASB_FilterField exp1 = asb.filter().field(Account.Name).eq('acme');
 * ```
 */
public with sharing class ASB_FilterField implements ASB_FilterExpression {
  private final List<SObjectField> fieldPath;
  private final String comparisonOperator;
  private final Object value;

  private String cachedFieldPathString;

  /**
   * @internal
   * @description constructs new `ASB_FilterField` instance.
   */
  public ASB_FilterField(List<SObjectField> fieldPath, String comparisonOperator, Object value) {
    this.fieldPath = fieldPath;
    this.comparisonOperator = comparisonOperator;
    this.value = value;
  }

  private String fieldPathString() {
    if (cachedFieldPathString == null) {
      List<String> fieldStrs = new List<String>();
      for (Integer i = 0; i < fieldPath.size() - 1; i++) {
        fieldStrs.add(fieldPath[i].getDescribe().getRelationshipName());
      }
      fieldStrs.add(fieldPath[fieldPath.size() - 1].getDescribe().getName());
      cachedFieldPathString = String.join(fieldStrs, '.');
    }
    return cachedFieldPathString;
  }

  /**
   * @description Returns query string and applies binds to given `ASB_BindContext`.
   * @param ASB_BindContext Bind context used for assigning bind properties.
   * @return SOQL stringified version of field expression
   */
  public String filterString(ASB_BindContext ctx) {
    String prefix = fieldPathString().right(40).replaceAll('_', '').replaceAll('\\.', '_').removeStart('_');
    String bindToken = ctx.bind(this, value, prefix);
    return fieldPathString() + ' ' + comparisonOperator + ' ' + bindToken;
  }
}
