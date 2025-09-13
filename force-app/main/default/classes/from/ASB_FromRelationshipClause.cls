public with sharing class ASB_FromRelationshipClause implements ASB_FromClause {
  @TestVisible
  private final Schema.SObjectField relationshipField;
  private final String childRelationshipName;

  private Schema.SObjectType cachedSObjType;
  private Schema.DescribeFieldResult cachedFieldDescribe;
  private Schema.ChildRelationship cachedChildRelationship;

  /**
   * Creates new instance of ASB_From based on given relationship field.
   * @param relationshipField the relationship to make the FROM clause for.
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
   * Converts the FROM clause to a query string.
   * @return  `String`
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'FROM ' + childRelationshipName;
  }

  /**
   * Returns ID field for the related object
   * @return  `SObjectField`
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
