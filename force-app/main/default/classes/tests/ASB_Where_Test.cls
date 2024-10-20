/**
 * Provides unit test coverage for ASB_Where class
 * @author Russell Laboe
 */
@isTest
private class ASB_Where_Test {
  /**
   * Ensures ComparisonOperator constants map as expected
   */
  @isTest
  static void comparisonOperators() {
    Test.startTest();
    System.Assert.areEqual(
      ASB_Where.ComparisonOperator.EQUALS,
      ASB_Where.EQUALS,
      'Unexpected ComparisonOperator value'
    );
    System.Assert.areEqual(
      ASB_Where.ComparisonOperator.GREATER_THAN,
      ASB_Where.GREATER_THAN,
      'Unexpected ComparisonOperator value'
    );
    System.Assert.areEqual(
      ASB_Where.ComparisonOperator.LESS_THAN,
      ASB_Where.LESS_THAN,
      'Unexpected ComparisonOperator value'
    );
    System.Assert.areEqual(
      ASB_Where.ComparisonOperator.NOT_EQUALS,
      ASB_Where.NOT_EQUALS,
      'Unexpected ComparisonOperator value'
    );
    System.Assert.areEqual(ASB_Where.ComparisonOperator.LIKEX, ASB_Where.LIKEX, 'Unexpected ComparisonOperator value');
    System.Assert.areEqual(ASB_Where.ComparisonOperator.INX, ASB_Where.INX, 'Unexpected ComparisonOperator value');
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given field expression
   */
  @isTest
  static void make() {
    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\'',
      'WHERE Owner.Profile.Name != \'Foo\'',
      'WHERE Name IN (\'Foo\', \'Bar\')',
      'WHERE Name LIKE :Foo',
      'WHERE NumberOfEmployees > 10',
      'WHERE NumberOfEmployees < 100'
    };

    String[] actualClauses = new List<String>{
      ASB_Where.make(Account.OwnerId, User.LastName, ASB_Where.ComparisonOperator.EQUALS, '\'Foo\'').clauseString(),
      ASB_Where.make(
          new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name },
          ASB_Where.ComparisonOperator.NOT_EQUALS,
          '\'Foo\''
        )
        .clauseString(),
      ASB_Where.make(Account.Name, ASB_Where.ComparisonOperator.INX, '(\'Foo\', \'Bar\')').clauseString(),
      ASB_Where.make(Account.Name, ASB_Where.ComparisonOperator.LIKEX, ':Foo').clauseString(),
      ASB_Where.make(Account.NumberOfEmployees, ASB_Where.ComparisonOperator.GREATER_THAN, '10').clauseString(),
      ASB_Where.make(Account.NumberOfEmployees, ASB_Where.ComparisonOperator.LESS_THAN, '100').clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `and` logical group
   */
  @isTest
  static void andx() {
    ASB_Where clause1 = ASB_Where.make(Account.OwnerId, User.LastName, ASB_Where.ComparisonOperator.EQUALS, '\'Foo\'');
    ASB_Where clause2 = ASB_Where.make(
      new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name },
      ASB_Where.ComparisonOperator.NOT_EQUALS,
      '\'Foo\''
    );
    ASB_Where clause3 = ASB_Where.make(Account.Name, ASB_Where.ComparisonOperator.INX, '(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\') AND Owner.LastName = \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\') AND Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      ASB_Where.andx(clause1, clause2).clauseString(),
      ASB_Where.andx(clause1, clause2, clause3).clauseString(),
      ASB_Where.andx(clause1, clause2, clause3, clause1).clauseString(),
      ASB_Where.andx(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }).clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `or` logical group
   */
  @isTest
  static void orx() {
    ASB_Where clause1 = ASB_Where.make(Account.OwnerId, User.LastName, ASB_Where.ComparisonOperator.EQUALS, '\'Foo\'');
    ASB_Where clause2 = ASB_Where.make(
      new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name },
      ASB_Where.ComparisonOperator.NOT_EQUALS,
      '\'Foo\''
    );
    ASB_Where clause3 = ASB_Where.make(Account.Name, ASB_Where.ComparisonOperator.INX, '(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\') OR Owner.LastName = \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\') OR Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      ASB_Where.orx(clause1, clause2).clauseString(),
      ASB_Where.orx(clause1, clause2, clause3).clauseString(),
      ASB_Where.orx(clause1, clause2, clause3, clause1).clauseString(),
      ASB_Where.orx(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }).clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }
}
