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
 * @class ASB_FromSObjectClause
 * @description FROM clause for a SOQL query based on a root SObject type. Implements ASB_FromClause.
 * @example
 *   ASB_FromSObjectClause fromClause = (ASB_FromSObjectClause)new ASB().make(Account.SObjectType).queryEngine.getASBFrom();
 */
public with sharing class ASB_FromSObjectClause implements ASB_FromClause {
  @TestVisible
  public final Schema.SObjectType sObjType;

  @TestVisible
  private String cachedSObjName;

  /**
   * @apexdoc
   * @description Creates new instance of ASB_From based on given SObjectType.
   * @param sObjType Type to make the FROM clause for.
   * @example
   *   ASB_FromSObjectClause fromClause = (ASB_FromSObjectClause)new ASB().make(Account.SObjectType).queryEngine.getASBFrom();
   */
  public ASB_FromSObjectClause(Schema.SObjectType sObjType) {
    this.sObjType = sObjType;
  }

  /**
   * @apexdoc
   * @description Converts the FROM clause to a query string.
   * @param ctx The bind context for query string generation.
   * @return String The FROM clause as a string.
   * @example
   *   String fromStr = new ASB().make(Account.SObjectType).queryEngine.getASBFrom().clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'FROM ' + getSObjectName();
  }

  /**
   * @apexdoc
   * @description Returns the Id field for the SObject in the FROM clause.
   * @return Schema.SObjectField The Id field.
   * @example
   *   Schema.SObjectField idField = new ASB().make(Account.SObjectType).queryEngine.getASBFrom().getIdField();
   */
  public Schema.SObjectField getIdField() {
    return sObjType.getDescribe().fields.getMap().get('Id');
  }

  public Integer hashCode() {
    return getSObjectName().hashCode();
  }

  public Boolean equals(Object obj) {
    return obj instanceof ASB_FromSObjectClause && getSObjectName() == ((ASB_FromSObjectClause) obj).getSObjectName();
  }

  private String getSObjectName() {
    if (cachedSObjName == null) {
      cachedSObjName = sObjType.getDescribe().getName();
    }
    return cachedSObjName;
  }

  public class InvalidRelationshipException extends Exception {
  }
}
