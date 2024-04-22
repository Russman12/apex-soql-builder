/**
 * Provides unit test coverage for ASB_Where class
 * @author Russell Laboe
 */
@isTest
private class ASB_Where_Test {
  static ASB_Where asbWhere = ASB_Where.instance();

  /**
   * Ensures `ASB_Where.instance()` returns singleton instance
   */
  @IsTest
  static void instance() {
    ASB_Where inst1 = ASB_Where.instance();
    ASB_Where inst2 = ASB_Where.instance();

    System.Assert.areEqual(inst1, inst2, 'class not a singleton');
  }

  /**
   * Ensures `expression(SObjectField field, ComparisonOperator operator, Object value)` returns `ASB_Where.ConditionExpression`
   */
  @IsTest
  static void expression() {
    System.Assert.isInstanceOfType(
      asbWhere.expression(Account.Name, ASB_Where.EQUALS, 'fred'),
      ASB_Where.ConditionExpression.class,
      'unexpected type returned'
    );
  }

  /**
   * Ensures `expression(SObjectField field, ComparisonOperator operator, Object value)` throws
   * expected exception if the value type is unhandled
   */
  @IsTest
  static void expressionUnhandledValueType() {
    try {
      asbWhere.expression(Account.Name, ASB_Where.EQUALS, new DummyValue());
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_Where.ASB_WhereException.class, 'unexpected exception thrown');
    }
  }

  /**
   * ensures `andx(Expression expression)` adds simple expression as expected
   */
  @IsTest
  static void andxExpression() {
    ASB_Where.Expression exp1 = asbWhere.expression(Account.Id, ASB_Where.EQUALS, '123');
    ASB_Where.Expression testExp = asbWhere.expression(Account.Name, ASB_Where.EQUALS, 'fred').andx(exp1);

    System.Assert.areEqual(
      'WHERE Name = \'fred\' AND Id = \'123\'',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures `andx(Expression expression)` adds multiple expressions as expected
   */
  @IsTest
  static void andxExpressionMulti() {
    ASB_Where.Expression exp1 = asbWhere.expression(Account.Id, ASB_Where.EQUALS, '123');
    ASB_Where.Expression exp2 = asbWhere.expression(Account.Type, ASB_Where.EQUALS, 'Customer');
    ASB_Where.Expression testExp = asbWhere.expression(Account.Name, ASB_Where.EQUALS, 'fred').andx(exp1).andx(exp2);

    System.Assert.areEqual(
      'WHERE Name = \'fred\' AND Id = \'123\' AND Type = \'Customer\'',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures `andx(Expression expression)` adds complex expressions as expected
   */
  @IsTest
  static void andxExpressionComplex() {
    ASB_Where.Expression exp1 = asbWhere.expression(Account.Id, ASB_Where.NOT_EQUALS, '123');
    ASB_Where.Expression exp2 = asbWhere.expression(Account.Type, ASB_Where.EQUALS, 'Customer').andx(exp1);
    ASB_Where.Expression testExp = asbWhere.expression(Account.Name, ASB_Where.LIKEX, 'fred').andx(exp2);

    System.Assert.areEqual(
      'WHERE Name LIKE \'fred\' AND (Type = \'Customer\' AND Id != \'123\')',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures `andx(SObjectField field, ComparisonOperator operator, String value)` adds expected expression
   */
  @IsTest
  static void andxField() {
    ASB_Where.Expression testExp = asbWhere.expression(Account.Id, ASB_Where.EQUALS, '123')
      .andx(Account.Type, ASB_Where.EQUALS, 'Customer');

    System.Assert.areEqual(
      'WHERE Id = \'123\' AND Type = \'Customer\'',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures `andx(SObjectField field, ComparisonOperator operator, String value)` adds expected expression when called multiple times
   */
  @IsTest
  static void andxFieldMulti() {
    ASB_Where.Expression testExp = asbWhere.expression(Account.Id, ASB_Where.EQUALS, '123')
      .andx(Account.Name, ASB_Where.EQUALS, 'fred')
      .andx(Account.Type, ASB_Where.EQUALS, 'Customer');

    System.Assert.areEqual(
      'WHERE Id = \'123\' AND Name = \'fred\' AND Type = \'Customer\'',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures a complex scanerio produces expected clause
   */
  @IsTest
  static void complex1() {
    ASB_Where.Expression exp1 = asbWhere.expression(Account.Industry, ASB_Where.EQUALS, 'Technology')
      .andx(Account.Type, ASB_Where.NOT_EQUALS, 'Customer');
    ASB_Where.Expression testExp = asbWhere.expression(Account.Name, ASB_Where.LIKEX, ':name')
      .andx(Account.Type, ASB_Where.EQUALS, 'Customer')
      .andx(Account.NumberOfEmployees, ASB_Where.EQUALS, 100)
      .group()
      .orx(exp1);

    System.Assert.areEqual(
      'WHERE (Name LIKE :name AND Type = \'Customer\' AND NumberOfEmployees = 100) OR (Industry = \'Technology\' AND Type != \'Customer\')',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  /**
   * ensures a complex scanerio produces expected clause
   */
  @IsTest
  static void complex2() {
    ASB_Where.Expression exp1 = asbWhere.expression(Account.Industry, ASB_Where.EQUALS, 'Technology')
      .orx(Account.Type, ASB_Where.NOT_EQUALS, 'Customer');
    ASB_Where.Expression testExp = asbWhere.expression(Account.Name, ASB_Where.LIKEX, ':name')
      .orx(Account.Type, ASB_Where.EQUALS, 'Customer')
      .orx(Account.NumberOfEmployees, ASB_Where.EQUALS, 100)
      .group()
      .andx(exp1);

    System.Assert.areEqual(
      'WHERE (Name LIKE :name OR Type = \'Customer\' OR NumberOfEmployees = 100) AND (Industry = \'Technology\' OR Type != \'Customer\')',
      testExp.toClause().toClauseString(),
      'unexpected clause string returned'
    );
  }

  private class DummyValue {
  }
}
