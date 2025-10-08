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
 * @description Represents a subquery SELECT clause builder for SOQL queries. Implements ASB_Selectable.
 * @group Clause
 * @see ASB_Selectable
 * @see ASB_SubSelectClause
 * @example
 * ```
 *   ASB_SubSelectClause subSelect = new ASB().subSelection()
 *     .field(Contact.Email)
 *     .parent(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
 *   String soql = subSelect.clauseString(new ASB_BindContext());
 * ```
 */
public with sharing class ASB_SubSelectClause implements ASB_Selectable {
  private final ASB_SelectEngine selectEngine;

  /**
   * @description Constructs a new ASB_SubSelectClause for the given SObject type.
   * @param sObjType The SObject type for the subquery SELECT clause.
   * @example
   * ```
   *   ASB_SubSelectClause subSelect = new ASB().subSelection();
   * ```
   */
  public ASB_SubSelectClause(SObjectType sObjType) {
    this.selectEngine = new ASB_SelectEngine(sObjType);
  }

  /**
   * @description Adds a field to the subquery SELECT clause.
   * @param field Field to add to select clause.
   * @return ASB_SubSelectClause for chaining.
   * @example
   * ```
   *   new ASB().subSelection().field(Contact.Email);
   * ```
   */
  public ASB_SubSelectClause field(Schema.SObjectField field) {
    selectEngine.addField(field);
    return this;
  }

  /**
   * @description Adds a parent record field to the subquery SELECT clause.
   * @param fieldPath Path to parent field as a list of SObjectFields.
   * @return ASB_SubSelectClause for chaining.
   * @example
   * ```
   *   new ASB().subSelection().parent(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
   * ```
   */
  public ASB_SubSelectClause parent(List<Schema.SObjectField> fieldPath) {
    selectEngine.addParent(fieldPath);
    return this;
  }

  /**
   * @description Adds a parent record field to the subquery SELECT clause using two SObjectFields.
   * @param relField1 First field in the path.
   * @param relField2 Second field in the path.
   * @return ASB_SubSelectClause for chaining.
   * @example
   * ```
   *   new ASB().subSelection().parent(Contact.AccountId, Account.Name);
   * ```
   */
  public ASB_SubSelectClause parent(Schema.SObjectField relField1, Schema.SObjectField relField2) {
    return parent(new List<Schema.SObjectField>{ relField1, relField2 });
  }

  /**
   * @description Returns the subquery SELECT clause as a query string.
   * @param ctx The bind context for query string generation.
   * @return The subquery SELECT clause as a String.
   * @example
   * ```
   *   String soql = new ASB().subSelection().field(Contact.Email).clauseString(new ASB_BindContext());
   * ```
   */
  public String clauseString(ASB_BindContext ctx) {
    return selectEngine.clauseString(ctx);
  }

  /**
   * @description Merges the elements of this subquery select clause into another ASB_SubSelectClause instance.
   * @param subSelectClause The target subquery select clause to merge into.
   * @example
   * ```
   *   new ASB().subSelection().mergeInto(otherSubSelectClause);
   * ```
   */
  public void mergeInto(ASB_SubSelectClause subSelectClause) {
    selectEngine.mergeInto(subSelectClause.selectEngine);
  }
}
