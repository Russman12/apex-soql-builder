/**
 * Provides unit test coverage for ASB_Select class
 * @author Russell Laboe
 */
@isTest
private class ASB_Select_Test {
  /**
   * Ensures adding field produces correct clause
   */
  @isTest
  static void field() {
    Test.startTest();
    String clauseStr = (new ASB_Select().field(Account.Id)).field(Account.Name).clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void subQuery() {
    Test.startTest();
    String clauseStr = (new ASB_Select().field(Account.Id))
      .subQuery(new ASB_SubQuery(Contact.AccountId).selectField(Contact.Id))
      .clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, (SELECT Id FROM Contacts)', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding parent query produces correct clause
   */
  @isTest
  static void parent() {
    Test.startTest();
    String clauseStr = (new ASB_Select().field(Account.Id))
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.Name })
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Owner.Name, Owner.Profile.Name', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding the same elements multiple times does not produce duplicate Select elements.
   */
  @isTest
  static void deduplicate() {
    List<Schema.SobjectField> parentRelationshipPath1 = new List<Schema.SobjectField>{ Account.OwnerId, User.Name };
    List<Schema.SobjectField> parentRelationshipPath2 = new List<Schema.SobjectField>{ Account.OwnerId, User.Id };

    ASB_SubQuery subQuery1 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.FirstName);
    ASB_SubQuery subQuery2 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.LastName);
    ASB_SubQuery subQuery3 = new ASB_SubQuery(User.AccountId).selectField(User.Name);
    Test.startTest();
    String clauseStr1 = (new ASB_Select().field(Account.Id)).field(Account.Id).clauseString();
    String clauseStr2 = (new ASB_Select().field(Account.Id))
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath2)
      .clauseString();
    String clauseStr3 = (new ASB_Select().field(Account.Id))
      .subQuery(subQuery1)
      .subQuery(subQuery2)
      .subQuery(subQuery3)
      .clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id', clauseStr1, 'Unexpected clause string returned');
    System.Assert.areEqual('SELECT Id, Owner.Name, Owner.Id', clauseStr2, 'Unexpected clause string returned');
    System.Assert.areEqual(
      'SELECT Id, (SELECT Id, FirstName, LastName FROM Contacts), (SELECT Id, Name FROM Users)',
      clauseStr3,
      'Unexpected clause string returned'
    );
  }
}
