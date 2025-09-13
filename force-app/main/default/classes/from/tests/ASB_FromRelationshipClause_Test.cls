/**
 * @description Unit tests for ASB_FromRelationshipClause.
 * Ensures correct behavior for relationship-based FROM clause logic.
 * @author Russell Laboe
 */
@IsTest
private class ASB_FromRelationshipClause_Test {
  /**
   * Ensures constructor and clauseString method function as expected.
   */
  @IsTest
  static void constructorAndClauseString() {
    // Contact.AccountId is a valid parent relationship (Contacts subquery under Account)
    Schema.SObjectField relField = Contact.AccountId;

    Test.startTest();
    ASB_FromRelationshipClause instance = new ASB_FromRelationshipClause(relField);
    Test.stopTest();

    System.Assert.areEqual(
      'FROM Contacts',
      instance.clauseString(new ASB_BindContext()),
      'Clause string should return FROM with relationship name'
    );
    System.Assert.areEqual(
      Contact.Id,
      instance.getIdField(),
      'getIdField should return Id field of the related SObject'
    );
  }

  /**
   * Ensures equality and hashCode methods function as expected.
   */
  @IsTest
  static void equalityAndHashCode() {
    ASB_FromRelationshipClause one = new ASB_FromRelationshipClause(Contact.AccountId);
    ASB_FromRelationshipClause two = new ASB_FromRelationshipClause(Contact.AccountId);
    ASB_FromRelationshipClause three = new ASB_FromRelationshipClause(Case.AccountId);

    System.Assert.areEqual(one, two, 'Two instances with same relationship field should be equal');
    System.Assert.areNotEqual(one, three, 'Different relationship fields should not be equal');
    System.Assert.areEqual(one.hashCode(), two.hashCode(), 'Equal objects must have equal hashCodes');
  }

  /**
   * Ensures exception is thrown when a non-relationship field is used in the constructor.
   */
  @IsTest
  static void constructorNonRelationshipField() {
    Schema.SObjectField nonRelField = Contact.Name;

    Test.startTest();
    try {
      new ASB_FromRelationshipClause(nonRelField);
      System.Assert.fail('expected exception was not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_FromRelationshipClause.InvalidRelationshipException.class,
        'unexpected exception thrown: ' + e
      );
    }
    Test.stopTest();
  }

  /**
   * Ensures exception is thrown when an invalid relationship field is used in the constructor.
   */
  @IsTest
  static void constructorInvalidRelationshipField() {
    // OwnerId is a lookup but not valid for querying as a subquery
    Schema.SObjectField invalidRelField = Account.OwnerId;

    Test.startTest();
    try {
      new ASB_FromRelationshipClause(invalidRelField);
      System.Assert.fail('expected exception was not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_FromRelationshipClause.InvalidRelationshipException.class,
        'unexpected exception thrown: ' + e
      );
    }
    Test.stopTest();
  }
}
