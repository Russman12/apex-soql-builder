@isTest
public with sharing class ASB_OrderBy_Test {
  /**
   * Ensures clauseString() returns expected string when given list of fields
   */
  @isTest
  static void clauseStringconstructor() {
    ASB_OrderBy asbOrder = new ASB_OrderBy(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual('ORDER BY Name, Id', asbOrder.clauseString(null), 'unexpected Order By clause returned');
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when called direction
   */
  @isTest
  static void clauseStringNullsx() {
    ASB_OrderBy asbOrder = new ASB_OrderBy(new List<Schema.SObjectField>{ Account.Name, Account.Id });

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
   * Ensures clauseString() returns expected string when called nullsx
   */
  @isTest
  static void clauseStringDirection() {
    ASB_OrderBy asbOrder = new ASB_OrderBy(new List<Schema.SObjectField>{ Account.Name, Account.Id });

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
   * Ensures clauseString() returns expected complex string when called
   */
  @isTest
  static void clauseStringComplex() {
    ASB_OrderBy asbOrder = new ASB_OrderBy(new List<Schema.SObjectField>{ Account.Name, Account.Id });

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
