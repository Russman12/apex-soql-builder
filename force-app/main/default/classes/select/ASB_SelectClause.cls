/**
 * Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * @class ASB_SelectClause
 * @description Represents a SELECT clause builder for SOQL queries. Implements ASB_Selectable.
 * @example
 *   ASB_SelectClause selectClause = new ASB().selection()
 *     .field(Account.Name)
 *     .parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
 *   String soql = selectClause.clauseString(new ASB_BindContext());
 */
public with sharing class ASB_SelectClause implements ASB_Selectable {
  private final ASB_SelectEngine selectEngine;

  /**
   * @apexdoc
   * @description Constructs a new ASB_SelectClause for the given SObject type.
   * @param sObjType The SObject type for the SELECT clause.
   * @example
   *   ASB_SelectClause selectClause = new ASB().selection();
   */
  public ASB_SelectClause(Schema.SObjectType sObjType) {
    this.selectEngine = new ASB_SelectEngine(sObjType);
  }

  /**
   * @apexdoc
   * @description Adds a field to the SELECT clause.
   * @param field Field to add to select clause.
   * @return ASB_SelectClause for chaining.
   * @example
   *   new ASB().selection().field(Account.Name);
   */
  public ASB_SelectClause field(Schema.SObjectField field) {
    selectEngine.addField(field);
    return this;
  }

  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause.
   * @param fieldPath Path to parent field as a list of SObjectFields.
   * @return ASB_SelectClause for chaining.
   * @example
   *   new ASB().selection().parent(new List<Schema.SObjectField>{ Opportunity.Account, Account.Name });
   */
  public ASB_SelectClause parent(List<Schema.SObjectField> fieldPath) {
    selectEngine.addParent(fieldPath);
    return this;
  }
  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause using two SObjectFields.
   * @param fieldPath1 First field in the path.
   * @param fieldPath2 Second field in the path.
   * @return ASB_SelectClause for chaining.
   * @example
   *   new ASB().selection().parent(Opportunity.Account, Account.Name);
   */
  public ASB_SelectClause parent(Schema.SObjectField fieldPath1, Schema.SObjectField fieldPath2) {
    return parent(new List<Schema.SObjectField>{ fieldPath1, fieldPath2 });
  }
  /**
   * @apexdoc
   * @description Adds a parent record field to the SELECT clause using three SObjectFields.
   * @param fieldPath1 First field in the path.
   * @param fieldPath2 Second field in the path.
   * @param fieldPath3 Third field in the path.
   * @return ASB_SelectClause for chaining.
   * @example
   *   new ASB().selection().parent(Opportunity.Account, Account.Parent, Account.Name);
   */
  public ASB_SelectClause parent(
    Schema.SObjectField fieldPath1,
    Schema.SObjectField fieldPath2,
    Schema.SObjectField fieldPath3
  ) {
    return parent(new List<Schema.SObjectField>{ fieldPath1, fieldPath2, fieldPath3 });
  }

  /**
   * @apexdoc
   * @description Adds a subquery to the SELECT clause.
   * @param subquery The subquery builder to add.
   * @return ASB_SelectClause for chaining.
   * @example
   *   new ASB().selection().subquery(subQueryBuilder);
   */
  public ASB_SelectClause subquery(ASB_SubQueryBuilder subquery) {
    selectEngine.mergeSubQuery(subquery);
    return this;
  }

  /**
   * @apexdoc
   * @description Returns the SELECT clause as a query string.
   * @param ctx The bind context for query string generation.
   * @return The SELECT clause as a String.
   * @example
   *   String soql = new ASB().selection().field(Account.Name).clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    return selectEngine.clauseString(ctx);
  }

  /**
   * @apexdoc
   * @description Merges the elements of this select clause into another ASB_SelectClause instance.
   * @param selectClause The target select clause to merge into.
   * @example
   *   new ASB().selection().mergeInto(otherSelectClause);
   */
  public void mergeInto(ASB_SelectClause selectClause) {
    selectEngine.mergeInto(selectClause.selectEngine);
  }
}
