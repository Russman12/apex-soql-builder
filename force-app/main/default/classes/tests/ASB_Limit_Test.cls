/**
 * Provides unit test coverage for ASB_Limit class
 * @author Russell Laboe
 */
@isTest
private class ASB_Limit_Test {
  /**
   * Ensures toClauseString() returns expected clause String
   */
  @IsTest
  static void toClauseString() {
    System.Assert.areEqual(
      'LIMIT 10',
      new ASB_Limit(10).toClauseString(),
      'unexpected LIMIT clause string returned'
    );
  }
}
