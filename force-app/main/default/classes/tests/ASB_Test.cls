@isTest
public with sharing class ASB_Test {
  private static ASB factory = new ASB();

  private static ASB_Where whereExp = new ASB_Where(
    (new ASB_Where.ComparisonOperator(new List<Schema.SObjectField>{ Account.Id })).equals().literal('test')
  );

  /**
   * Ensures make executes as expected
   */
  @isTest
  static void make() {
    Test.startTest();
    ASB_QueryBuilder result = factory.make(Account.getSObjectType());
    Test.stopTest();

    System.Assert.isNotNull(result, 'unexpected ASB_QueryBuilder returned');
  }

  /**
   * Ensures selection executes as expected
   */
  @isTest
  static void selection() {
    Test.startTest();
    ASB_Select result = factory.selection();
    Test.stopTest();

    System.Assert.isNotNull(result, 'unexpected ASB_Select returned');
  }

  /**
   * Ensures subQuery executes as expected
   */
  @isTest
  static void subQuery() {
    Test.startTest();
    ASB_SubQuery result = factory.subQuery(Account.ParentId);
    Test.stopTest();

    System.Assert.isNotNull(result, 'unexpected ASB_SubQuery returned');
  }

  /**
   * Ensures all fromx method execute as expected
   */
  @isTest
  static void fromx() {
    Test.startTest();
    ASB_From result1 = factory.fromx(Account.getSObjectType());
    ASB_From result2 = factory.fromx(Account.ParentId);
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_From returned');
    System.Assert.isNotNull(result2, 'unexpected ASB_From returned');
  }

  /**
   * Ensures all whereField methods execute as expected
   */
  @isTest
  static void whereField() {
    Test.startTest();
    ASB_Where.ComparisonOperator result1 = factory.whereField(Account.Name);
    ASB_Where.ComparisonOperator result2 = factory.whereField(Account.Name, Account.ParentId);
    ASB_Where.ComparisonOperator result3 = factory.whereField(new List<Schema.SObjectField>{ Account.Name });
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_Where.ComparisonOperator returned');
    System.Assert.isNotNull(result2, 'unexpected ASB_Where.ComparisonOperator returned');
    System.Assert.isNotNull(result3, 'unexpected ASB_Where.ComparisonOperator returned');
  }

  /**
   * Ensures all whereAnd methods executes as expected
   */
  @isTest
  static void whereAnd() {
    Test.startTest();
    ASB_Where result1 = factory.whereAnd(whereExp, whereExp);
    ASB_Where result2 = factory.whereAnd(whereExp, whereExp, whereExp);
    ASB_Where result3 = factory.whereAnd(new List<ASB_Where>{ whereExp });
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_Where returned');
    System.Assert.isNotNull(result2, 'unexpected ASB_Where returned');
    System.Assert.isNotNull(result3, 'unexpected ASB_Where returned');
  }

  /**
   * Ensures all whereOr methods execute as expected
   */
  @isTest
  static void whereOr() {
    Test.startTest();
    ASB_Where result1 = factory.whereOr(whereExp, whereExp);
    ASB_Where result2 = factory.whereOr(whereExp, whereExp, whereExp);
    ASB_Where result3 = factory.whereOr(new List<ASB_Where>{ whereExp });
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_Where returned');
    System.Assert.isNotNull(result2, 'unexpected ASB_Where returned');
    System.Assert.isNotNull(result3, 'unexpected ASB_Where returned');
  }

  /**
   * Ensures all orderByfields methods execute as expected
   */
  @isTest
  static void orderByFields() {
    Test.startTest();
    ASB_OrderBy result1 = factory.orderByfield(Account.Name);
    ASB_OrderBy result2 = factory.orderByfields(Account.Name, Account.ParentId);
    ASB_OrderBy result3 = factory.orderByfields(new List<Schema.SObjectField>{ Account.Name });
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_OrderBy returned');
    System.Assert.isNotNull(result2, 'unexpected ASB_OrderBy returned');
    System.Assert.isNotNull(result3, 'unexpected ASB_OrderBy returned');
  }

  /**
   * Ensures all orderByfields methods execute as expected
   */
  @isTest
  static void recordLimit() {
    Test.startTest();
    ASB_Limit result1 = factory.recordLimit(10);
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_Limit returned');
  }
}
