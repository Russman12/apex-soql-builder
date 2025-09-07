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
    ASB_ClauseDetail clauseDetail = (new ASB_Select().field(Account.Id)).field(Account.Name).clauseDetail();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseDetail.getClauseString(), 'Unexpected clause string returned');
    System.Assert.areEqual(new Map<String, Object>(), clauseDetail.getBindings(), 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void subQuery() {
    Test.startTest();
    ASB_ClauseDetail clauseDetail = (new ASB_Select().field(Account.Id))
      .subQuery(new ASB_SubQuery(Contact.AccountId).selectField(Contact.Id))
      .clauseDetail();
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, (SELECT Id FROM Contacts)',
      clauseDetail.getClauseString(),
      'Unexpected clause string returned'
    );
  }

  /**
   * Ensures adding parent query produces correct clause
   */
  @isTest
  static void parent() {
    Test.startTest();
    ASB_ClauseDetail clauseDetail = (new ASB_Select().field(Account.Id))
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.Name })
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .clauseDetail();
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Owner.Name, Owner.Profile.Name',
      clauseDetail.getClauseString(),
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
    ASB_ClauseDetail clauseDetail1 = (new ASB_Select().field(Account.Id)).field(Account.Id).clauseDetail();
    ASB_ClauseDetail clauseDetail2 = (new ASB_Select().field(Account.Id))
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath2)
      .clauseDetail();
    ASB_ClauseDetail clauseDetail3 = (new ASB_Select().field(Account.Id))
      .subQuery(subQuery1)
      .subQuery(subQuery2)
      .subQuery(subQuery3)
      .clauseDetail();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id', clauseDetail1.getClauseString(), 'Unexpected clause string returned');
    System.Assert.areEqual(
      'SELECT Id, Owner.Name, Owner.Id',
      clauseDetail2.getClauseString(),
      'Unexpected clause string returned'
    );
    System.Assert.areEqual(
      'SELECT Id, (SELECT Id, FirstName, LastName FROM Contacts), (SELECT Id, Name FROM Users)',
      clauseDetail3.getClauseString(),
      'Unexpected clause string returned'
    );
  }
}
