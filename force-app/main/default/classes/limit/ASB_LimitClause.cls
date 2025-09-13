/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_LimitClause implements ASB_Clause {
  @TestVisible
  private static final String BIND_NAME = 'RECORD_LIMIT';

  private String bindPrefix = '';
  private Map<String, Object> binds = new Map<String, Object>();

  private final Integer limitx;

  /**
   * Creates new limit instance.
   * @param limitx value to set limit to.
   */
  public ASB_LimitClause(Integer limitx) {
    if (limitx <= 0) {
      throw new IllegalArgumentException('LIMIT must be positive');
    }
    this.limitx = limitx;
  }

  /**
   * Returns complete clause string
   * @return   `String`
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'LIMIT ' + ctx.bind(this, this.limitx, BIND_NAME);
  }

  public class IllegalArgumentException extends Exception {
  }
}
