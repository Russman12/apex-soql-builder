/**
 * Provides unit test coverage for ASB_FROM class
 * @author Russell Laboe
 */
@isTest
private class ASB_From_Test {
  /**
   * Ensures toClauseString() returns expected clause String
   */
  @IsTest
  static void toClauseString() {
    System.Assert.areEqual(
      'FROM Account',
      new ASB_From(Account.getSObjectType()).toClauseString(),
      'unexpected FROM clause string returned'
    );
  }
}
