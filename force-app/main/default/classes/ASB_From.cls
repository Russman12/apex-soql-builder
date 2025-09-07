/**
 * SOQL FROM clause.
 * @description This class encompasses functionality relating to building a FROM clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_From implements ASB_Clause {
  @TestVisible
  private final String stringVal;
  @TestVisible
  public final Schema.SObjectType sObjType;

  /**
   * Creates new instance of ASB_From based on given SObjectType.
   * @param sObjType Type to make the FROM clause for.
   */
  public ASB_From(Schema.SObjectType sObjType) {
    this.stringVal = sObjType.getDescribe().getName();
    this.sObjType = sObjType;
  }

  /**
   * Creates new instance of ASB_From based on given relationship field.
   * @param relationshipField the relationship to make the FROM clause for.
   */
  public ASB_From(Schema.sObjectField relationshipField) {
    Schema.DescribeFieldResult fieldDescribe = relationshipField.getDescribe();

    if (fieldDescribe.getRelationshipName() == null) {
      throw new InvalidRelationshipException(relationshipField + ' is not a relationship field');
    }

    for (Schema.ChildRelationship cr : fieldDescribe.getReferenceTo()[0].getDescribe().getChildRelationships()) {
      if (cr.getField() == relationshipField) {
        this.stringVal = cr.getRelationshipName();
        break;
      }
    }

    if (this.stringVal == null) {
      throw new InvalidRelationshipException(relationshipField + ' is not a relationship that can be queried');
    }
    this.sObjType = fieldDescribe.getSObjectType();
  }

  /**
   * Converts the FROM clause to a query string.
   * @return  `String`
   */
  public ASB_ClauseDetail clauseDetail() {
    return new ASB_ClauseDetail('FROM ' + this.stringVal);
  }

  public Integer hashCode() {
    return this.stringVal.hashCode();
  }

  public Boolean equals(Object obj) {
    return this.hashCode().equals(obj.hashCode());
  }

  public class InvalidRelationshipException extends Exception {
  }
}
