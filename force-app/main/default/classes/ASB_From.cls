public with sharing class ASB_From implements ASB_SOQL.Clause {
  private final SObjectType sObj;
  public ASB_From(SObjectType sObj) {
    this.sObj = sObj;
  }

  public String toClauseString() {
    return 'FROM ' + this.sObj;
  }
}
