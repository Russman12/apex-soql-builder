/**
 * Provides unit test coverage for ASB_Where class
 * @author Russell Laboe
 */
@isTest
private class ASB_Where_Test {
  /**
   * Ensures toClauseString() returns expected clause String with provided ConditionExpression
   */
  @isTest
  static void toClauseString() {
    ASB_Where ce1 = new ASB_Where(Account.Name, ASB_Where.ComparisonOperator.LIKEX, '%my-name1%');
    ASB_Where ce2 = new ASB_Where(Account.Id, ASB_Where.ComparisonOperator.NOT_EQUALS, '1234')
      .orx(new ASB_Where(Account.Type, ASB_Where.ComparisonOperator.EQUALS, 'Turkey'));
    ASB_Where ce3 = ce1.andx(ce2);

    System.Assert.areEqual(
      'WHERE Name LIKE \'%my-name1%\' AND (Id != \'1234\' OR Type = \'Turkey\')',
      ce3.toClauseString(),
      'unexpected WHERE clause string returned'
    );
  }

  /**
   * Ensures toSOQLString() returns expected String when constructed with String Value
   */
  @isTest
  static void toSOQLStringStringVal() {
    System.Assert.areEqual(
      'Name = \'my-name1\'',
      new ASB_Where(Account.Name, ASB_Where.ComparisonOperator.EQUALS, 'my-name1').toSOQLString(),
      'unexpected SOQL string returned'
    );
  }

  /**
   * Ensures toSOQLString() returns expected String when constructed with String Value
   */
  @isTest
  static void toSOQLStringStringValBind() {
    System.Assert.areEqual(
      'Name = :var',
      new ASB_Where(Account.Name, ASB_Where.ComparisonOperator.EQUALS, ':var').toSOQLString(),
      'unexpected SOQL string returned'
    );
  }

  /**
   * Ensures toSOQLString() returns expected String when constructed with an Integer Value
   */
  @isTest
  static void toSOQLStringIntVal() {
    System.Assert.areEqual(
      'Name = 10',
      new ASB_Where(Account.Name, ASB_Where.ComparisonOperator.EQUALS, 10).toSOQLString(),
      'unexpected SOQL string returned'
    );
  }

  /**
   * Ensures toSOQLString() returns expected String when constructed with String Value
   */
  @isTest
  static void toSOQLStringMultiItem() {
    System.Assert.areEqual(
      '(Name = \'my-name1\' OR Id != \'1234\')',
      new ASB_Where(Account.Name, ASB_Where.ComparisonOperator.EQUALS, 'my-name1')
        .orx(new ASB_Where(Account.Id, ASB_Where.ComparisonOperator.NOT_EQUALS, '1234'))
        .toSOQLString(),
      'unexpected SOQL string returned'
    );
  }
}
