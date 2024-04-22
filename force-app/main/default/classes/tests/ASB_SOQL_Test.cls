/**
 * Provides unit test coverage for ASB_SOQL class
 * @author Russell Laboe
 */
@isTest
private class ASB_SOQL_Test {
  /**
   * ensures that the instance method returns singleton instance
   */
  @isTest
  static void instanceReturnsSingletonInstance() {
    ASB_SOQL inst1 = ASB_SOQL.instance();
    ASB_SOQL inst2 = ASB_SOQL.instance();

    System.Assert.areEqual(inst1, inst2, 'instances are not the same');
  }

  /**
   * ensures that `builder()` returns expected builder
   */
  @IsTest
  static void builder() {
    ASB_SOQL.Builder bldr = (ASB_SOQL.Builder) ASB_SOQL.instance().builder(Account.getSObjectType());

    System.Assert.areEqual(Account.getSObjectType(), bldr.fromClause.sObjectType, 'unexpected fromSObjectType set');
    System.Assert.isFalse(bldr.selectClause.elements.isEmpty(), 'select elements should not be empty');
  }

  /**
   * ensures that `builder.build()` creates `ASB_SOQL.SOQL` with expected select clause.
   */
  @IsTest
  static void builderBuildSelect() {
    ASB_SOQL.SOQL soql = (ASB_SOQL.SOQL) ASB_SOQL.instance()
      .builder(Account.getSObjectType())
      .selectx(Account.Name)
      .build();

    System.Assert.areEqual('SELECT Id, Name', soql.clauses[0].toClauseString(), 'unexpected clause string returned');
  }

  /**
   * ensures that `builder.build()` creates `ASB_SOQL.SOQL` with expected from clause.
   */
  @IsTest
  static void builderBuildFrom() {
    ASB_SOQL.SOQL soql = (ASB_SOQL.SOQL) ASB_SOQL.instance().builder(Account.getSObjectType()).build();

    System.Assert.areEqual('FROM Account', soql.clauses[1].toClauseString(), 'unexpected clause string returned');
  }

  /**
   * ensures that `builder.build()` creates `ASB_SOQL.SOQL` with expected where clause.
   */
  @IsTest
  static void builderBuildWhere() {
    ASB_SOQL.SOQL soql = (ASB_SOQL.SOQL) ASB_SOQL.instance().builder(Account.getSObjectType()).wherex().build();

    System.Assert.areEqual('WHERE Account', soql.clauses[1].toClauseString(), 'unexpected clause string returned');
  }

  private class DummyConditionalExpression extends ASB_Where {
  }
}
