/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 * @example
 *   ASB_LimitClause limit = new ASB().recordLimit(10);
 */
public with sharing class ASB_LimitClause implements ASB_Clause {
  @TestVisible
  private static final String BIND_NAME = 'RECORD_LIMIT';

  private String bindPrefix = '';
  private Map<String, Object> binds = new Map<String, Object>();

  private final Integer limitx;

  /**
   * @apexdoc
   * @description Creates new limit instance.
   * @param limitx value to set limit to.
   * @example
   *   new ASB().recordLimit(10);
   */
  public ASB_LimitClause(Integer limitx) {
    if (limitx <= 0) {
      throw new IllegalArgumentException('LIMIT must be positive');
    }
    this.limitx = limitx;
  }

  /**
   * @apexdoc
   * @description Returns complete clause string
   * @param ctx The bind context for query string generation.
   * @return   String
   * @example
   *   String soql = new ASB().recordLimit(10).clauseString(new ASB_BindContext());
   */
  public String clauseString(ASB_BindContext ctx) {
    return 'LIMIT ' + ctx.bind(this, this.limitx, BIND_NAME);
  }

  public class IllegalArgumentException extends Exception {
  }
}
