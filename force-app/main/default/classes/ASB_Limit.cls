/**
 * SOQL LIMIT clause.
 * @description This class encompasses functionality relating to building a LIMIT clause.
 * @author Russell Laboe
 * @group Apex SOQL Builder
 */
public with sharing class ASB_Limit implements ASB_Clause, ASB_Bindable {
  @TestVisible
  private static final String BIND_NAME = 'RECORD_LIMIT';

  private String bindPrefix = '';
  private Map<String, Object> binds = new Map<String, Object>();

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

  private String getBindName() {
    return this.bindPrefix + BIND_NAME;
  }

  /**
   * Returns complete clause string
   * @return   `String`
   */
  public String clauseString() {
    this.binds = new Map<String, Object>{ this.getBindName() => this.limitx };
    return 'LIMIT :' + this.getBindName();
  }

  /* -- Bindable interface -- */

  public void setBindPrefix(String prefix) {
    this.bindPrefix = prefix;
  }

  public Map<String, Object> getBinds() {
    return this.binds;
  }

  public class IllegalArgumentException extends Exception {
  }
}
