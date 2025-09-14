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
 * @description Entry point for Apex SOQL Builder. Provides methods to construct various ASB query components.
 * @see ASB_Clause
 * @see ASB_QueryBuilder
 * @see ASB_SelectClause
 * @see ASB_SubQueryBuilder
 * @see ASB_SubSelectClause
 * @see ASB_WhereClause
 * @see ASB_OrderByClause
 * @see ASB_LimitClause
 * @example
 * ```
 *   ASB asb = new ASB();
 *   ASB_QueryBuilder builder = asb.make(Account.SObjectType)
 *     .selection(asb.selection().field(Account.Name))
 *     .filter(asb.filter().field(Account.Name).eq('Google'));
 * ```
 */
public with sharing class ASB {
  /**
   * @description Creates new ASB_QueryBuilder instance for the given SObject type.
   * @param sObjType Type to make the FROM clause for.
   * @return ASB_QueryBuilder
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_QueryBuilder builder = asb.make(Account.SObjectType);
   * ```
   */
  public ASB_QueryBuilder make(Schema.SObjectType sObjType) {
    return new ASB_QueryBuilder(fromSObject(sObjType), selection());
  }

  /**
   * @description Creates a new ASB_SelectClause instance.
   * @return ASB_SelectClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_SelectClause select = asb.selection();
   * ```
   */
  public ASB_SelectClause selection() {
    return new ASB_SelectClause(null);
  }

  /**
   * @description Creates a new ASB_SubQueryBuilder from the given relationship field.
   * @param relationshipField Relationship field from child to parent.
   * @return ASB_SubQueryBuilder
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_SubQueryBuilder subQuery = asb.subQuery(Contact.AccountId);
   * ```
   */
  public ASB_SubQueryBuilder subQuery(Schema.sObjectField relationshipField) {
    return new ASB_SubQueryBuilder(fromRelationship(relationshipField), subSelection());
  }

  /**
   * @description Creates a new ASB_SubSelectClause instance.
   * @return ASB_SubSelectClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_SubSelectClause subSelect = asb.subSelection();
   * ```
   */
  public ASB_SubSelectClause subSelection() {
    return new ASB_SubSelectClause(null);
  }

  /**
   * @description Creates a new ASB_WhereClause.Builder instance.
   * @return ASB_WhereClause.Builder
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_WhereClause.Builder where = asb.filter();
   * ```
   */
  public ASB_WhereClause.Builder filter() {
    return new ASB_WhereClause.Builder();
  }

  /**
   * @description Sets a field in the ORDER BY clause.
   * @param field The field to order by.
   * @return ASB_OrderByClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_OrderByClause orderBy = asb.orderByField(Account.Name);
   * ```
   */
  public ASB_OrderByClause orderByField(Schema.SObjectField field) {
    return orderByFields(new List<Schema.SObjectField>{ field });
  }

  /**
   * @description Sets two fields in the ORDER BY clause.
   * @param field1 The first field.
   * @param field2 The second field.
   * @return ASB_OrderByClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_OrderByClause orderBy = asb.orderByFields(Account.Name, Account.Id);
   * ```
   */
  public ASB_OrderByClause orderByFields(Schema.SObjectField field1, Schema.SObjectField field2) {
    return orderByFields(new List<Schema.SObjectField>{ field1, field2 });
  }

  /**
   * @description Sets fields in the ORDER BY clause.
   * @param fields Array of fields to order by.
   * @return ASB_OrderByClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_OrderByClause orderBy = asb.orderByFields(new List<Schema.SObjectField>{ Account.Name, Account.Id });
   * ```
   */
  public ASB_OrderByClause orderByFields(Schema.SObjectField[] fields) {
    return new ASB_OrderByClause(fields);
  }

  /**
   * @description Returns new ASB_LimitClause instance for the query.
   * @param recordLimit The record limit to set.
   * @return ASB_LimitClause
   * @example
   * ```
   *   ASB asb = new ASB();
   *   ASB_LimitClause limit = asb.recordLimit(10);
   * ```
   */
  public ASB_LimitClause recordLimit(Integer recordLimit) {
    return new ASB_LimitClause(recordLimit);
  }

  private ASB_FromSObjectClause fromSObject(Schema.SObjectType sObjType) {
    return new ASB_FromSObjectClause(sObjType);
  }
  private ASB_FromRelationshipClause fromRelationship(Schema.SObjectField relationshipField) {
    return new ASB_FromRelationshipClause(relationshipField);
  }
}
