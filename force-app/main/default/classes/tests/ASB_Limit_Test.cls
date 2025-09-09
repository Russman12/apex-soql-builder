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
    Integer expectedLimit = 10;
    ASB_Limit asbLimit = new ASB_Limit(expectedLimit);
    System.Assert.areEqual(
      'LIMIT :' + ASB_Limit.BIND_NAME,
      asbLimit.clauseString(),
      'unexpected LIMIT clause string returned'
    );
    System.Assert.areEqual(
      expectedLimit,
      asbLimit.getBinds().get(ASB_Limit.BIND_NAME),
      'unexpected LIMIT clause string returned'
    );
  }

  /**
   * Ensures expected exception is thrown when invalid argument is given
   */
  @IsTest
  static void illegalArgument() {
    Test.startTest();
    try {
      new ASB_Limit(-10);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_Limit.IllegalArgumentException.class, 'Unexpected exception thrown');
    }
    Test.stopTest();
  }
}
