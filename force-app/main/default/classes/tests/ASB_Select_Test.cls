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
    String clauseStr = (ASB_Select.make().field(Account.Id)).field(Account.Name).clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void subQuery() {
    Test.startTest();
    String clauseStr = (ASB_Select.make().field(Account.Id))
      .subQuery(ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.Id))
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
    String clauseStr = (ASB_Select.make().field(Account.Id))
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

    ASB_SubQuery subQuery1 = ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.FirstName);
    ASB_SubQuery subQuery2 = ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.LastName);
    ASB_SubQuery subQuery3 = ASB_SubQuery.relatedBy(User.AccountId).selectField(User.Name);
    Test.startTest();
    String clauseStr1 = (ASB_Select.make().field(Account.Id)).field(Account.Id).clauseString();
    String clauseStr2 = (ASB_Select.make().field(Account.Id))
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath2)
      .clauseString();
    String clauseStr3 = (ASB_Select.make().field(Account.Id))
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
