/**
 * SOQL FROM clause.
 * @description This class encompasses functionality relating to building a FROM clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_From implements ASB_Clause {
  @TestVisible
  private final String stringVal;
  @TestVisible
  public final Schema.SObjectType sObjType;

  /**
   * Creates new insantace of ASB_From based on given SObjectType.
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
    for (Schema.ChildRelationship cr : fieldDescribe.getReferenceTo()[0].getDescribe().getChildRelationships()) {
      if (cr.getField() == relationshipField) {
        this.stringVal = cr.getRelationshipName();
        break;
      }
    }
    this.sObjType = fieldDescribe.getSObjectType();
  }

  /**
   * Converts the FROM clause to a query string.
   * @return  `String`
   */
  public String clauseString() {
    return 'FROM ' + this.stringVal;
  }
}
