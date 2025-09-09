/**
 * Provides unit test coverage for ASB_Select class
 * @author Russell Laboe
 */
@isTest
private class ASB_Select_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  /**
   * Ensures adding field produces correct clause
   */
  @isTest
  static void field() {
    ASB_Select selection = new ASB_Select();
    Test.startTest();
    String clauseString = selection.field(Account.Id).field(Account.Name).clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseString, 'Unexpected clause string returned');
    System.Assert.areEqual(new Map<String, Object>(), ctx.getBinds(), 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void subQuery() {
    Test.startTest();
    String clauseString = (new ASB_Select().field(Account.Id))
      .subQuery(new ASB_SubQuery(Contact.AccountId).selectField(Contact.Id))
      .clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, (SELECT Id FROM Contacts)', clauseString, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding parent query produces correct clause
   */
  @isTest
  static void parent() {
    Test.startTest();
    String clauseString = (new ASB_Select().field(Account.Id))
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.Name })
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Owner.Name, Owner.Profile.Name',
      clauseString,
      'Unexpected clause string returned'
    );
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
    String clauseString1 = (new ASB_Select().field(Account.Id)).field(Account.Id).clauseString(ctx);
    String clauseString2 = (new ASB_Select().field(Account.Id))
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath2)
      .clauseString(ctx);
    String clauseString3 = (new ASB_Select().field(Account.Id))
      .subQuery(subQuery1)
      .subQuery(subQuery2)
      .subQuery(subQuery3)
      .clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id', clauseString1, 'Unexpected clause string returned');
    System.Assert.areEqual('SELECT Id, Owner.Name, Owner.Id', clauseString2, 'Unexpected clause string returned');
    System.Assert.areEqual(
      'SELECT Id, (SELECT Id, FirstName, LastName FROM Contacts), (SELECT Id, Name FROM Users)',
      clauseString3,
      'Unexpected clause string returned'
    );
  }
}
