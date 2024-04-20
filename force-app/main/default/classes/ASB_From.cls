/**
 * SOQL FROM clause.
 * @description This class encompasses functionality relating to building a FROM clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_From implements ASB_SOQL.Clause {
  private final SObjectType sObjectType;
  public ASB_From(SObjectType sObjectType) {
    this.sObjectType = sObjectType;
  }

  /**
   * Returns complete clause string
   * @return  `String`
   */
  public String toClauseString() {
    return 'FROM ' + this.sObjectType.getDescribe().getName();
  }
}
