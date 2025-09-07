/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_Limit implements ASB_Clause {
  @TestVisible
  private static final String BIND_NAME = 'RECORD_LIMIT';

  private final Integer limitx;

  /**
   * Creates new limit instance.
   * @param limitx value to set limit to.
   */
  public ASB_Limit(Integer limitx) {
    if (limitx <= 0) {
      throw new IllegalArgumentException('LIMIT must be positive');
    }
    this.limitx = limitx;
  }

  public Map<String, Object> getBindings() {
    return new Map<String, Object>{ BIND_NAME => this.limitx };
  }

  /**
   * Returns complete clause string
   * @return   `String`
   */
  public ASB_ClauseDetail clauseDetail() {
    return new ASB_ClauseDetail('LIMIT :' + BIND_NAME, getBindings());
  }

  public class IllegalArgumentException extends Exception {
  }
}
