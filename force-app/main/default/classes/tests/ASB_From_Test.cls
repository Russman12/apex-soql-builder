/**
 * Provides unit test coverage for ASB_FROM class
 * @author Russell Laboe
 */
@isTest
private class ASB_From_Test {
  static ASB_From asbFrom = ASB_From.instance();

  /**
   * Ensures `ASB_From.instance()` returns singleton instance
   */
  @IsTest
  static void instance() {
    ASB_From inst1 = ASB_From.instance();
    ASB_From inst2 = ASB_From.instance();

    System.Assert.areEqual(inst1, inst2, 'class not a singleton');
  }

  /**
   * Ensures `clause` returns a `ASB_From.Clause`
   */
  @IsTest
  static void clause() {
    System.Assert.isInstanceOfType(
      asbFrom.clause(Account.getSObjectType()),
      ASB_From.Clause.class,
      'unexpected type returned'
    );
  }

  /**
   * Ensures `toClauseString()` returns expected clause String
   */
  @IsTest
  static void toClauseString() {
    System.Assert.areEqual(
      'FROM Account',
      asbFrom.clause(Account.getSObjectType()).toClauseString(),
      'unexpected FROM clause string returned'
    );
  }
}
