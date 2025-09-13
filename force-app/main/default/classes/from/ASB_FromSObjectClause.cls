public with sharing class ASB_FromSObjectClause implements ASB_FromClause {
  @TestVisible
  public final Schema.SObjectType sObjType;

  @TestVisible
  private String cachedSObjName;

  /**
   * Creates new instance of ASB_From based on given SObjectType.
   * @param sObjType Type to make the FROM clause for.
   */
  public ASB_FromSObjectClause(Schema.SObjectType sObjType) {
    this.sObjType = sObjType;
  }

  /**
   * Converts the FROM clause to a query string.
   * @return  `String`
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'FROM ' + getSObjectName();
  }

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
