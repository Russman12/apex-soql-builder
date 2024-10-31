/**
 * Provides test coverage for ASB class
 * @author Russell Laboe
 */
@isTest
public with sharing class ASB_Test {
  @isTest
  static void clauseString() {
    ASB_SubQuery contactsSelect = ASB_SubQuery.relatedBy(Contact.AccountId)
      .selectField(Contact.Id)
      .selectField(Contact.Name);

    ASB_Where testAccWhere = ASB_Where.field(Account.Name).equals().string('test');
    ASB_Where confirmedAccs = ASB_Where.field(Account.Name).isIn().bind('accNames');
    ASB_Where largeAccs = ASB_Where.field(Account.NumberOfEmployees).greaterThan().literal('10');

    ASB_Where confirmedLargeAccs = ASB_Where.groupAnd(confirmedAccs, largeAccs);

    ASB_Select selection = ASB_Select.make()
      .field(Account.Id)
      .field(Account.Name)
      .field(Account.OwnerId)
      .parent(Account.OwnerId, User.LastName)
      .parent(Account.OwnerId, User.ProfileId, Profile.Name)
      .subQuery(contactsSelect);

    ASB asb = ASB.sObject(Account.getSObjectType())
      .selection(selection)
      .filter(ASB_Where.groupOr(testAccWhere, confirmedLargeAccs))
      .orderBy(ASB_OrderBy.field(Account.Name).descending())
      .recordLimit(5);

    Test.startTest();
    String soqlString = asb.soqlString();
    Test.stopTest();

    System.assertEquals(
      'SELECT Id, Name, OwnerId, Owner.LastName, Owner.Profile.Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Name = \'test\' OR (Name IN :accNames AND NumberOfEmployees > 10) ORDER BY Name DESC LIMIT 5',
      soqlString,
      'unexpected soql string returned'
    );
  }

  /**
   * Ensures query() returns expected results
   */
  @isTest
  static void query() {
    Account a1 = new Account(Name = 'test1');
    Account a2 = new Account(Name = 'test2');
    Account a3 = new Account(Name = 'test3');

    Account[] accs = new List<Account>{ a1, a2, a3 };
    insert accs;

    //build Query
    Test.startTest();
    List<Account> queriedAccs = (List<Account>) ASB.sObject(Account.getSObjectType())
      .selection(ASB_Select.make().field(Account.Id).field(Account.Name))
      .filter(ASB_Where.field(Account.Name).equals().string('test2'))
      .query();
    Test.stopTest();

    System.Assert.areEqual(1, queriedAccs.size(), 'unexpected number of accounts returned');
    System.Assert.areEqual('test2', queriedAccs[0].Name, 'unexpected account name returned');
    System.Assert.isNotNull(queriedAccs[0].Id, 'id not returned');
  }

  /**
   * Ensures query(binds) returns expected results
   */
  @isTest
  static void queryBinds() {
    Account a1 = new Account(Name = 'test1');
    Account a2 = new Account(Name = 'test2');
    Account a3 = new Account(Name = 'test3');

    Account[] accs = new List<Account>{ a1, a2, a3 };
    insert accs;

    //build Query
    Test.startTest();
    List<Account> queriedAccs = (List<Account>) ASB.sObject(Account.getSObjectType())
      .selection(ASB_Select.make().field(Account.Id).field(Account.Name))
      .filter(ASB_Where.field(Account.Name).isIn().bind('accNames'))
      .orderBy(ASB_OrderBy.field(Account.Name).ascending())
      .query(new Map<String, Object>{ 'accNames' => new List<String>{ 'test2', 'test3' } });
    Test.stopTest();

    System.Assert.areEqual(2, queriedAccs.size(), 'unexpected number of accounts returned');
    System.Assert.areEqual('test2', queriedAccs[0].Name, 'unexpected account name returned');
    System.Assert.areEqual('test3', queriedAccs[1].Name, 'unexpected account name returned');
    System.Assert.isNotNull(queriedAccs[0].Id, 'id not returned');
    System.Assert.isNotNull(queriedAccs[1].Id, 'id not returned');
  }
}
