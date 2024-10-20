/**
 * Provides unit test coverage for ASB_Limit class
 * @author Russell Laboe
 */
@isTest
private class ASB_Limit_Test {
  /**
   * Ensures clauseString() returns expected clause String
   */
  @IsTest
  static void clauseString() {
    ASB_Limit asbLimit = new ASB_Limit(10);
    System.Assert.areEqual('LIMIT 10', asbLimit.clauseString(), 'unexpected LIMIT clause string returned');
  }
}
