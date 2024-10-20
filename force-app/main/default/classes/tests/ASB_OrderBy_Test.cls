@isTest
public with sharing class ASB_OrderBy_Test {
  /**
   * Ensures clauseString() returns expected string when given list of fields
   */
  @isTest
  static void clauseStringFieldsList() {
    ASB_OrderBy asbOrder = ASB_OrderBy.fields(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual('ORDER BY Name, Id', asbOrder.clauseString(), 'unexpected Order By clause returned');
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when given 2 fields
   */
  @isTest
  static void clauseStringFields2() {
    ASB_OrderBy asbOrder = ASB_OrderBy.fields(Account.Name, Account.Id);

    Test.startTest();
    System.Assert.areEqual('ORDER BY Name, Id', asbOrder.clauseString(), 'unexpected Order By clause returned');
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when given 1 field
   */
  @isTest
  static void clauseStringField() {
    ASB_OrderBy asbOrder = ASB_OrderBy.field(Account.Name);

    Test.startTest();
    System.Assert.areEqual('ORDER BY Name', asbOrder.clauseString(), 'unexpected Order By clause returned');
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when called direction
   */
  @isTest
  static void clauseStringNullsx() {
    ASB_OrderBy asbOrder = ASB_OrderBy.fields(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id ASC',
      asbOrder.ascending().clauseString(),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id DESC',
      asbOrder.descending().clauseString(),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected string when called nullsx
   */
  @isTest
  static void clauseStringDirection() {
    ASB_OrderBy asbOrder = ASB_OrderBy.fields(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id NULLS FIRST',
      asbOrder.nullsFirst().clauseString(),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id NULLS LAST',
      asbOrder.nullsLast().clauseString(),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }

  /**
   * Ensures clauseString() returns expected complex string when called
   */
  @isTest
  static void clauseStringComplex() {
    ASB_OrderBy asbOrder = ASB_OrderBy.fields(new List<Schema.SObjectField>{ Account.Name, Account.Id });

    Test.startTest();
    System.Assert.areEqual(
      'ORDER BY Name, Id DESC NULLS FIRST',
      asbOrder.descending().nullsFirst().clauseString(),
      'unexpected Order By clause returned'
    );
    System.Assert.areEqual(
      'ORDER BY Name, Id ASC NULLS LAST',
      asbOrder.nullsLast().ascending().clauseString(),
      'unexpected Order By clause returned'
    );
    Test.stopTest();
  }
}
