/**
 * Provides unit test coverage for ASB_Limit class
 * @author Russell Laboe
 */
@isTest
private class ASB_Limit_Test {
  static ASB_Limit asbLimit = ASB_Limit.instance();

  /**
   * Ensures `ASB_Limit.instance()` returns singleton instance
   */
  @IsTest
  static void instance() {
    ASB_Limit inst1 = ASB_Limit.instance();
    ASB_Limit inst2 = ASB_Limit.instance();

    System.Assert.areEqual(inst1, inst2, 'class not a singleton');
  }

  /**
   * Ensures `clause` returns a `ASB_Limit.Clause`
   */
  @IsTest
  static void clause() {
    System.Assert.isInstanceOfType(asbLimit.clause(10), ASB_Limit.Clause.class, 'unexpected type returned');
  }

  /**
   * Ensures toClauseString() returns expected clause String
   */
  @IsTest
  static void toClauseString() {
    System.Assert.areEqual('LIMIT 10', asbLimit.clause(10).toClauseString(), 'unexpected LIMIT clause string returned');
  }
}
