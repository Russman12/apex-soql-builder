@isTest
public with sharing class ASB_Test {
  private static ASB factory = new ASB();

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
   * Ensures all filter().field methods execute as expected
   */
  @isTest
  static void filter() {
    Test.startTest();
    ASB_Where.Builder result1 = factory.filter();
    Test.stopTest();

    System.Assert.isNotNull(result1, 'unexpected ASB_Where.Builder returned');
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
