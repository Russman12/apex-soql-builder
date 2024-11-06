/**
 * Provides unit test coverage for ASB_Where class
 * @author Russell Laboe
 */
@isTest
private class ASB_Where_Test {
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
      new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.OwnerId, User.LastName })
        .equals()
        .string('Foo')
        .clauseString(),
      new ASB_Where.ComparisonOperator(new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
        .notEquals()
        .string('Foo')
        .clauseString(),
      new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.Name })
        .isIn()
        .literal('(\'Foo\', \'Bar\')')
        .clauseString(),
      new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.Name })
        .isLike()
        .bind('Foo')
        .clauseString(),
      new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.NumberOfEmployees })
        .greaterThan()
        .literal('10')
        .clauseString(),
      new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.NumberOfEmployees })
        .lessThan()
        .literal('100')
        .clauseString()
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
    ASB_Where clause1 = new ASB_Where.ComparisonOperator(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .equals()
      .string('Foo');
    ASB_Where clause2 = new ASB_Where.ComparisonOperator(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .notEquals()
      .string('Foo');
    ASB_Where clause3 = new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.Name })
      .isIn()
      .literal('(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\') AND Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2 })).clauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 })).clauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseString()
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
    ASB_Where clause1 = new ASB_Where.ComparisonOperator(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .equals()
      .string('Foo');
    ASB_Where clause2 = new ASB_Where.ComparisonOperator(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .notEquals()
      .string('Foo');
    ASB_Where clause3 = new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.Name })
      .isIn()
      .literal('(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\') OR Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2 })).clauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 })).clauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }
}
