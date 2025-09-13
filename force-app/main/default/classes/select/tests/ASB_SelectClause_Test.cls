/**
 * Provides unit test coverage for ASB_SelectClause (root-level SELECT)
 * @author Russell Laboe
 */
@IsTest
private class ASB_SelectClause_Test {
  private static final ASB_BindContext ctx = new ASB_BindContext();

  /**
   * Ensures adding fields produces correct clause
   */
  @IsTest
  static void field() {
    ASB_SelectClause selection = new ASB_SelectClause(null);
    Test.startTest();
    String clauseString = selection.field(Account.Id).field(Account.Name).clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseString, 'Unexpected clause string returned');
    System.Assert.areEqual(new Map<String, Object>(), ctx.getBinds(), 'No binds expected');
  }

  /**
   * Ensures adding parent query fields produces correct clause
   */
  @IsTest
  static void parent() {
    Test.startTest();
    String clauseString = (new ASB_SelectClause(null).field(Account.Id))
      .parent(new List<Schema.SObjectField>{ Account.OwnerId, User.Name })
      .parent(new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name })
      .clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Owner.Name, Owner.Profile.Name',
      clauseString,
      'Unexpected clause string returned'
    );
  }

  /**
   * Ensures duplicate fields, parents, and subqueries are deduplicated correctly
   */
  @IsTest
  static void deduplicate() {
    List<Schema.SObjectField> parentPath1 = new List<Schema.SObjectField>{ Account.OwnerId, User.Name };
    List<Schema.SObjectField> parentPath2 = new List<Schema.SObjectField>{ Account.OwnerId, User.Id };

    Test.startTest();
    String clauseString1 = new ASB_SelectClause(null).field(Account.Id).field(Account.Id).clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id', clauseString1, 'Unexpected clause string for fields');
  }
}
