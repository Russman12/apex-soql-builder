/**
 * SOQL FROM clause.
 * @description This class encompasses functionality relating to building a FROM clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_From {
  private static ASB_From instance;

  public static ASB_From instance() {
    if (instance == null) {
      instance = new ASB_From();
    }
    return instance;
  }

  public ASB_SOQLClause clause(SObjectType sObjectType) {
    return new ASB_From.Clause(sObjectType);
  }

  @TestVisible
  private class clause implements ASB_SOQLClause {
    @TestVisible
    private final SObjectType sObjectType;
    public clause(SObjectType sObjectType) {
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
}
