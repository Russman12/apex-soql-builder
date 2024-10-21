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
  static void addField() {
    ASB_Select asbSelect = (new ASB_Select(Account.Id)).field(Account.Name);

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void addSubQuery() {
    ASB_Select asbSelect = (new ASB_Select(Account.Id))
      .subQuery(ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.Id));

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, (SELECT Id FROM Contacts)', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding parent query produces correct clause
   */
  @isTest
  static void addParentQuery() {
    ASB_Select asbSelect = (new ASB_Select(Account.Id))
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.Name })
      .parent(new List<Schema.SobjectField>{ Account.OwnerId, User.ProfileId, Profile.Name });

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Owner.Name, Owner.Profile.Name', clauseStr, 'Unexpected clause string returned');
  }
}
