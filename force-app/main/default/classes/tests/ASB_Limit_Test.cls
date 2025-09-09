/**
 * Provides unit test coverage for ASB_Limit class
 * @author Russell Laboe
 */
@isTest
private class ASB_Limit_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  /**
   * Ensures clauseString() returns expected clause String
   */
  @IsTest
  static void clauseString() {
    Integer expectedLimit = 10;
    ASB_Limit asbLimit = new ASB_Limit(expectedLimit);
    System.Assert.areEqual(
      'LIMIT :RECORD_LIMIT1',
      asbLimit.clauseString(ctx),
      'unexpected LIMIT clause string returned'
    );
    System.Assert.areEqual(
      expectedLimit,
      ctx.getBinds().get('RECORD_LIMIT1'),
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
