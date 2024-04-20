/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public class ASB_Limit implements ASB_SOQL.Clause {
  private final Integer limitx;
  public ASB_Limit(Integer limitx) {
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
