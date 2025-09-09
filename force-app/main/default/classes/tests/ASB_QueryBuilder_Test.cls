/**
 * Provides test coverage for ASB_QueryBuilder class
 * @author Russell Laboe
 */
@isTest
public with sharing class ASB_QueryBuilder_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  //TODO: mock this
  private static ASB asb = new ASB();

  @isTest
  static void clauseString() {
    ASB_SubQuery contactsSelect = new ASB_SubQuery(Contact.AccountId).selectField(Contact.Id).selectField(Contact.Name);
    String accName1 = 'test';
    List<String> accNames = new List<String>{ 'name1', 'name2' };
    Integer lgAccNum = 10;
    Integer recordLimit = 5;

    ASB_Where testAccWhere = asb.filter().field(Account.Name).eq(accName1);
    ASB_Where confirmedAccs = asb.filter().field(Account.Name).isIn(accNames);
    ASB_Where largeAccs = asb.filter().field(Account.NumberOfEmployees).gt(lgAccNum);

    ASB_Where confirmedLargeAccs = asb.filter().andGroup(confirmedAccs, largeAccs);

    ASB_Select selection = new ASB_Select()
      .field(Account.Id)
      .field(Account.Name)
      .field(Account.OwnerId)
      .parent(Account.OwnerId, User.LastName)
      .parent(Account.OwnerId, User.ProfileId, Profile.Name)
      .subQuery(contactsSelect);

    ASB_QueryBuilder queryBuilder = asb.make(Account.getSObjectType())
      .selection(selection)
      .filter(asb.filter().orGroup(testAccWhere, confirmedLargeAccs))
      .orderBy(asb.orderByfield(Account.Name).descending())
      .recordLimit(recordLimit);

    Test.startTest();
    String queryString = queryBuilder.queryDetail(ctx);
    Test.stopTest();

    System.assertEquals(
      'SELECT Id, Name, OwnerId, Owner.LastName, Owner.Profile.Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Name = :Name1 OR (Name IN :Name2 AND NumberOfEmployees > :NumberOfEmployees1) ORDER BY Name DESC LIMIT :RECORD_LIMIT1',
      queryString,
      'unexpected soql string returned'
    );

    System.assertEquals(
      new Map<String, Object>{
        'RECORD_LIMIT1' => recordLimit,
        'Name1' => accName1,
        'Name2' => accNames,
        'NumberOfEmployees1' => lgAccNum
      },
      ctx.getBinds(),
      'unexpected bindings returned'
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
    List<Account> queriedAccs = (List<Account>) asb.make(Account.getSObjectType())
      .selection(new ASB_Select().field(Account.Id).field(Account.Name))
      .filter(asb.filter().field(Account.Name).eq('test2'))
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
    List<Account> queriedAccs = (List<Account>) asb.make(Account.getSObjectType())
      .selection(new ASB_Select().field(Account.Id).field(Account.Name))
      .filter(asb.filter().field(Account.Name).isIn(new List<String>{ 'test2', 'test3' }))
      .orderBy(asb.orderByfield(Account.Name).ascending())
      .query();
    Test.stopTest();

    System.Assert.areEqual(2, queriedAccs.size(), 'unexpected number of accounts returned');
    System.Assert.areEqual('test2', queriedAccs[0].Name, 'unexpected account name returned');
    System.Assert.areEqual('test3', queriedAccs[1].Name, 'unexpected account name returned');
    System.Assert.isNotNull(queriedAccs[0].Id, 'id not returned');
    System.Assert.isNotNull(queriedAccs[1].Id, 'id not returned');
  }
}
