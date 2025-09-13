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
 * @class ASB_FromRelationshipClause
 * @description FROM clause for a SOQL subquery based on a relationship field. Implements ASB_FromClause.
 * @example
 *   ASB_FromRelationshipClause fromRel = (ASB_FromRelationshipClause)new ASB().subQuery(Contact.AccountId).relatedBy();
 */
public with sharing class ASB_FromRelationshipClause implements ASB_FromClause {
  @TestVisible
  private final Schema.SObjectField relationshipField;
  private final String childRelationshipName;

  private Schema.SObjectType cachedSObjType;
  private Schema.DescribeFieldResult cachedFieldDescribe;
  private Schema.ChildRelationship cachedChildRelationship;

  /**
   * @apexdoc
   * @description Creates new instance of ASB_From based on given relationship field.
   * @param relationshipField The relationship to make the FROM clause for.
   * @example
   *   ASB_FromRelationshipClause fromRel = (ASB_FromRelationshipClause)new ASB().subQuery(Contact.AccountId).relatedBy();
   */
  public ASB_FromRelationshipClause(Schema.SObjectField relationshipField) {
    this.relationshipField = relationshipField;
    if (fieldDescribe().getSOAPType() != Schema.SOAPType.ID) {
      throw new InvalidRelationshipException(cachedFieldDescribe + ' is not a relationship field');
    }

    childRelationshipName = getChildRelationship().getRelationshipName();
    if (childRelationshipName == null) {
      throw new InvalidRelationshipException(cachedFieldDescribe + ' is not a relationship that can be queried');
    }
  }

  /**
   * @apexdoc
   * @description Converts the FROM clause to a query string.
   * @param ctx The bind context for query string generation.
   * @return String The FROM clause as a string.
   * @example
   *   String fromStr = new ASB().subQuery(Contact.AccountId).relatedBy().clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'FROM ' + childRelationshipName;
  }

  /**
   * @apexdoc
   * @description Returns ID field for the related object.
   * @return Schema.SObjectField The Id field.
   * @example
   *   Schema.SObjectField idField = new ASB().subQuery(Contact.AccountId).relatedBy().getIdField();
   */
  public Schema.SObjectField getIdField() {
    return getSObjectType().getDescribe().fields.getMap().get('Id');
  }

  public Integer hashCode() {
    return relationshipField.hashCode();
  }

  public Boolean equals(Object obj) {
    return obj instanceof ASB_FromRelationshipClause &&
      relationshipField == ((ASB_FromRelationshipClause) obj).relationshipField;
  }

  private Schema.DescribeFieldResult fieldDescribe() {
    if (this.cachedFieldDescribe == null) {
      this.cachedFieldDescribe = this.relationshipField.getDescribe();
    }
    return this.cachedFieldDescribe;
  }

  private Schema.SObjectType getSObjectType() {
    if (cachedSObjType == null) {
      Schema.DescribeFieldResult fieldDescribe = relationshipField.getDescribe();

      cachedSObjType = fieldDescribe.getSObjectType();
    }
    return cachedSObjType;
  }

  private Schema.ChildRelationship getChildRelationship() {
    if (cachedChildRelationship == null) {
      for (Schema.ChildRelationship cr : fieldDescribe().getReferenceTo()[0].getDescribe().getChildRelationships()) {
        if (cr.getField() == relationshipField) {
          cachedChildRelationship = cr;
          break;
        }
      }
    }
    return this.cachedChildRelationship;
  }

  public class InvalidRelationshipException extends Exception {
  }
}
