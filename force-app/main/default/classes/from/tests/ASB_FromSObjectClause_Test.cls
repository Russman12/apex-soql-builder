/**
 * Provides unit test coverage for ASB_FromSObject
 * @author Russell Laboe
 */
@IsTest
private class ASB_FromSObjectClause_Test {
  /**
   * Ensures clauseString returns expected string
   */
  @IsTest
  static void constructorAndClauseString() {
    Schema.SObjectType sObjType = Account.SObjectType;

    Test.startTest();
    ASB_FromSObjectClause instance = new ASB_FromSObjectClause(sObjType);
    Test.stopTest();

    System.Assert.areEqual(
      'FROM Account',
      instance.clauseString(new ASB_BindContext()),
      'Clause string should return FROM with SObject name'
    );
    System.Assert.areEqual(Account.Id, instance.getIdField(), 'getIdField should return the Id field for the SObject');
  }

  /**
   * Ensures equality checks function as expected
   */
  @IsTest
  static void equalityAndHashCode() {
    ASB_FromSObjectClause one = new ASB_FromSObjectClause(Account.getSObjectType());
    ASB_FromSObjectClause two = new ASB_FromSObjectClause(Account.getSObjectType());
    ASB_FromSObjectClause three = new ASB_FromSObjectClause(Contact.getSObjectType());

    System.Assert.areEqual(one, two, 'Two instances for Account should be equal');
    System.Assert.areNotEqual(one, three, 'Account and Contact instances should not be equal');
    System.Assert.areEqual(one.hashCode(), two.hashCode(), 'Equal objects must have equal hashCodes');
  }
}
