@isTest
public with sharing class ASB_Test {
  @isTest
  static void clauseString1() {
    ASB contactsSelect = ASB.fromx(Contact.AccountId).selectx(Contact.Id).selectx(Contact.Name);

    ASB_Where testAccWhere = ASB_Where.make(Account.Name, ASB_Where.EQUALS, '\'test\'');
    ASB_Where confirmedAccs = ASB_Where.make(Account.Name, ASB_Where.INX, ':accNames');
    ASB_Where largeAccs = ASB_Where.make(Account.NumberOfEmployees, ASB_Where.GREATER_THAN, '10');

    ASB_Where confirmedLargeAccs = ASB_Where.andx(confirmedAccs, largeAccs);

    ASB asb = ASB.fromx(Account.getSObjectType())
      .selectx(Account.Id)
      .selectx(Account.Name)
      .selectx(Account.OwnerId)
      .selectParent(Account.OwnerId, User.LastName)
      .selectParent(Account.OwnerId, User.ProfileId, Profile.Name)
      .selectx(contactsSelect)
      .wherex(ASB_Where.orx(testAccWhere, confirmedLargeAccs))
      .orderBy(ASB_Order.byx(Account.Name).descx())
      .limitx(5);

    Test.startTest();
    String soqlString = asb.soqlString();
    Test.stopTest();

    System.assertEquals(
      'SELECT Id, Name, OwnerId, Owner.LastName, Owner.Profile.Name, (SELECT Id, Name FROM Contacts) FROM Account WHERE Name = \'test\' OR (Name IN :accNames AND NumberOfEmployees > 10)',
      soqlString,
      'unexpected soql string returned'
    );
  }
}
