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
      ASB_Where.field(Account.OwnerId, User.LastName).equals().string('Foo').clauseString(),
      ASB_Where.field(new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
        .notEquals()
        .string('Foo')
        .clauseString(),
      ASB_Where.field(Account.Name).isIn().literal('(\'Foo\', \'Bar\')').clauseString(),
      ASB_Where.field(Account.Name).isLike().bind('Foo').clauseString(),
      ASB_Where.field(Account.NumberOfEmployees).greaterThan().literal('10').clauseString(),
      ASB_Where.field(Account.NumberOfEmployees).lessThan().literal('100').clauseString()
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
    ASB_Where clause1 = ASB_Where.field(Account.OwnerId, User.LastName).equals().string('Foo');
    ASB_Where clause2 = ASB_Where.field(new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .notEquals()
      .string('Foo');
    ASB_Where clause3 = ASB_Where.field(Account.Name).isIn().literal('(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\') AND Owner.LastName = \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\' AND Name IN (\'Foo\', \'Bar\') AND Owner.LastName = \'Foo\' AND Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      ASB_Where.groupAnd(clause1, clause2).clauseString(),
      ASB_Where.groupAnd(clause1, clause2, clause3).clauseString(),
      ASB_Where.groupAnd(clause1, clause2, clause3, clause1).clauseString(),
      ASB_Where.groupAnd(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }).clauseString()
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
    ASB_Where clause1 = ASB_Where.field(Account.OwnerId, User.LastName).equals().string('Foo');
    ASB_Where clause2 = ASB_Where.field(new List<SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .notEquals()
      .string('Foo');
    ASB_Where clause3 = ASB_Where.field(Account.Name).isIn().literal('(\'Foo\', \'Bar\')');

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\')',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\') OR Owner.LastName = \'Foo\'',
      'WHERE Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\' OR Name IN (\'Foo\', \'Bar\') OR Owner.LastName = \'Foo\' OR Owner.Profile.Name != \'Foo\''
    };

    String[] actualClauses = new List<String>{
      ASB_Where.groupOr(clause1, clause2).clauseString(),
      ASB_Where.groupOr(clause1, clause2, clause3).clauseString(),
      ASB_Where.groupOr(clause1, clause2, clause3, clause1).clauseString(),
      ASB_Where.groupOr(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }).clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }
}
