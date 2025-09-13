/**
 * @description Unit tests for ASB_OrderByClause.
 * Ensures correct behavior for SOQL ORDER BY clause logic.
 */
@isTest
public with sharing class ASB_OrderByClause_Test {
  /**
   * Ensures clauseString() returns expected string when given list of fields.
   */
  @isTest
  static void clauseStringconstructor() {
    ASB_OrderByClause asbOrder = new ASB_OrderByClause(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual('ORDER BY Name, Id', asbOrder.clauseString(null), 'unexpected Order By clause returned');
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when called direction.
   */
  @isTest
  static void clauseStringNullsx() {
    ASB_OrderByClause asbOrder = new ASB_OrderByClause(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id ASC',
      asbOrder.ascending().clauseString(null),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id DESC',
      asbOrder.descending().clauseString(null),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when called nullsx.
   */
  @isTest
  static void clauseStringDirection() {
    ASB_OrderByClause asbOrder = new ASB_OrderByClause(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id NULLS FIRST',
      asbOrder.nullsFirst().clauseString(null),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id NULLS LAST',
      asbOrder.nullsLast().clauseString(null),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected complex string when called.
   */
  @isTest
  static void clauseStringComplex() {
    ASB_OrderByClause asbOrder = new ASB_OrderByClause(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id DESC NULLS FIRST',
      asbOrder.descending().nullsFirst().clauseString(null),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id ASC NULLS LAST',
      asbOrder.nullsLast().ascending().clauseString(null),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }
}
