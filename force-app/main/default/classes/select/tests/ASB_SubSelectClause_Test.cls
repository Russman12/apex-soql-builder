/**
 * @description Unit tests for ASB_SubSelectClause.
 * Ensures correct behavior for subquery SELECT clause logic.
 * @author Russell Laboe
 */
@isTest
private class ASB_SubSelectClause_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  /**
   * Ensures adding field produces correct clause.
   */
  @isTest
  static void field() {
    ASB_SubSelectClause selection = new ASB_SubSelectClause(null);
    Test.startTest();
    String clauseString = selection.field(Account.Id).field(Account.Name).clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name', clauseString, 'Unexpected clause string returned');
    System.Assert.areEqual(new Map<String, Object>(), ctx.getBinds(), 'Unexpected clause string returned');
  }

  /**
   * Ensures adding parent query produces correct clause.
   */
  @isTest
  static void parent() {
    Test.startTest();
    String clauseString = (new ASB_SubSelectClause(null).field(Account.Id))
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

    Test.startTest();
    String clauseString1 = (new ASB_SubSelectClause(null).field(Account.Id)).field(Account.Id).clauseString(ctx);
    String clauseString2 = (new ASB_SubSelectClause(null).parent(parentRelationshipPath1))
      .parent(parentRelationshipPath1)
      .parent(parentRelationshipPath2)
      .clauseString(ctx);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id', clauseString1, 'Unexpected clause string returned');
    System.Assert.areEqual('SELECT Owner.Name, Owner.Id', clauseString2, 'Unexpected clause string returned');
  }
}
