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
    ASB_Select asbSelect = new ASB_Select();
    asbSelect.add(Account.Id);
    asbSelect.add(Account.Name);

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Id,Name', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding subquery produces correct clause
   */
  @isTest
  static void addSubQuery() {
    ASB_Select asbSelect = new ASB_Select();
    asbSelect.add(ASB.fromx(Contact.AccountId).selectx(Contact.Id).selectx(Contact.Name));

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT (SELECT Id,Name FROM Contacts)', clauseStr, 'Unexpected clause string returned');
  }

  /**
   * Ensures adding parent query produces correct clause
   */
  @isTest
  static void addParentQuery() {
    ASB_Select asbSelect = new ASB_Select();
    asbSelect.addParent(new List<Schema.SObjectField>{ Account.OwnerId, User.Name });
    asbSelect.addParent(new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name });

    Test.startTest();
    String clauseStr = asbSelect.clauseString();
    Test.stopTest();

    System.Assert.areEqual('SELECT Owner.Name,Owner.Profile.Name', clauseStr, 'Unexpected clause string returned');
  }
}
