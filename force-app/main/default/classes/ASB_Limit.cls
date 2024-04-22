/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Limit {
  private static ASB_Limit instance;

  public static ASB_Limit instance() {
    if (instance == null) {
      instance = new ASB_Limit();
    }
    return instance;
  }

  public ASB_SOQLClause clause(Integer limitx) {
    return new ASB_Limit.Clause(limitx);
  }

  @TestVisible
  private class Clause implements ASB_SOQLClause {
    private final Integer limitx;
    private Clause(Integer limitx) {
      this.limitx = limitx;
    }

    /**
     * Returns complete clause string
     * @return   `String`
     */
    public String toClauseString() {
      return 'LIMIT ' + this.limitx;
    }
  }
}
