/**
 * Provides unit test coverage for ASB_FROM class
 * @author Russell Laboe
 */
@isTest
private class ASB_From_Test {
  /**
   * Ensures instance is constructed correctly when given SObjectType
   */
  @isTest
  static void constructorSObjectType() {
    Schema.SObjectType sObjType = Account.getSObjectType();

    Test.startTest();
    ASB_From instance = new ASB_From(sObjType);
    Test.stopTest();

    System.Assert.areEqual('Account', instance.stringVal, 'incorrect stringVal set');
    System.Assert.areEqual(Account.getSObjectType(), instance.sObjType, 'incorrecty sObjType set');
  }

  /**
   * Ensures instance is constructed correctly when given sObjectField
   */
  @isTest
  static void constructorSObjectField() {
    Schema.sObjectField sObjField = Contact.AccountId;

    Test.startTest();
    ASB_From instance = new ASB_From(sObjField);
    Test.stopTest();

    System.Assert.areEqual('Contacts', instance.stringVal, 'incorrect stringVal set');
    System.Assert.areEqual(Contact.getSObjectType(), instance.sObjType, 'incorrecty sObjType set');
  }

  /**
   * Ensures instance construction throws exception if non relationship field is provided
   */
  @isTest
  static void constructorSObjectFieldNotRelationship() {
    Schema.sObjectField sObjField = Contact.Id;

    Test.startTest();
    try {
      ASB_From instance = new ASB_From(sObjField);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_From.InvalidRelationshipException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }
  /**
   * Ensures instance construction throws exception if invalid relationship field is provided
   */
  @isTest
  static void constructorSObjectFieldInvalidRelationship() {
    Schema.sObjectField sObjField = Account.OwnerId;

    Test.startTest();
    try {
      ASB_From instance = new ASB_From(sObjField);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_From.InvalidRelationshipException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }
}
