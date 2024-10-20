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
  private final Schema.SObjectType sObjType;

  public ASB_From(Schema.SObjectType sObjType) {
    this.stringVal = sObjType.getDescribe().getName();
    this.sObjType = sObjType;
  }

  public ASB_From(Schema.sObjectField field) {
    Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    for (Schema.ChildRelationship cr : fieldDescribe.getReferenceTo()[0].getDescribe().getChildRelationships()) {
      if (cr.getField() == field) {
        this.stringVal = cr.getRelationshipName();
        break;
      }
    }
    this.sObjType = fieldDescribe.getSObjectType();
  }

  public String clauseString() {
    return 'FROM ' + this.stringVal;
  }
}
