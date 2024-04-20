/**
 * SOQL FROM clause.
 * @description This class encompasses functionality relating to building a FROM clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_From implements ASB_SOQL.Clause {
  private final SObjectType sObj;
  public ASB_From(SObjectType sObj) {
    this.sObj = sObj;
  }

  /**
   * Returns complete clause string
   * @return  `String`
   */
  public String toClauseString() {
    return 'FROM ' + this.sObj;
  }
}
