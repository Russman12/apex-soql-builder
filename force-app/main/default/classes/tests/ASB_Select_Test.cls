/**
 * Provides unit test coverage for ASB_Select class
 * @author Russell Laboe
 */
@isTest
private class ASB_Select_Test {
  static ASB_Select asbSelect = ASB_Select.instance();

  /**
   * Ensures `ASB_Select.instance()` returns singleton instance
   */
  @IsTest
  static void instance() {
    ASB_Select inst1 = ASB_Select.instance();
    ASB_Select inst2 = ASB_Select.instance();

    System.Assert.areEqual(inst1, inst2, 'class not a singleton');
  }

  /**
   * Ensures `make()` returns `ASB_Select.Elements`
   */
  @IsTest
  static void make() {
    System.Assert.isInstanceOfType(
      asbSelect.make(Account.getSObjectType()),
      ASB_Select.Elements.class,
      'unexpected type returned'
    );
  }

  /**
   * Ensures `toClause().toClauseString()` returns expected default clause String
   */
  @isTest
  static void toClauseStringDefault() {
    System.Assert.areEqual(
      'SELECT Id',
      asbSelect.make(Account.getSObjectType()).toClause().toClauseString(),
      'unexpected SELECT clause string returned'
    );
  }

  /**
   * Ensures `add(SObjectField field)` appends an SObjectField
   */
  @isTest
  static void addAppendsField() {
    System.Assert.areEqual(
      'SELECT Id, Name',
      asbSelect.make(Account.getSObjectType()).add(Account.Name).toClause().toClauseString(),
      'unexpected SELECT clause returned'
    );
  }

  /**
   * Ensures `add(SObjectField relationshipField, SObjectField field)` appends a relationship field
   */
  @isTest
  static void addAppendsRelationshipField() {
    System.Assert.areEqual(
      'SELECT Id, Owner.Id',
      asbSelect.make(Account.getSObjectType()).add(Account.OwnerId, User.Id).toClause().toClauseString(),
      'unexpected SELECT clause returned'
    );
  }

  /**
   * Ensures `combine(Elements selects)` merges elements
   */
  @isTest
  static void combine() {
    ASB_Select.Elements defaultElements = asbSelect.make(Account.getSObjectType()).add(Account.Name);
    System.Assert.areEqual(
      'SELECT Id, Name, Type',
      defaultElements.combine(asbSelect.make(Account.getSObjectType()).add(Account.Type)).toClause().toClauseString(),
      'unexpected SELECT clause returned'
    );
  }

  /**
   * Ensures elements are not duplicate
   */
  @isTest
  static void elementsDeduplicated() {
    ASB_Select.Elements elements = asbSelect.make(Account.getSObjectType())
      .add(Account.Name)
      .add(Account.Name)
      .add(Account.OwnerId, User.Id)
      .add(Account.OwnerId, User.Id);

    System.Assert.areEqual(
      'SELECT Id, Name, Owner.Id',
      elements.toClause().toClauseString(),
      'unexpected SELECT clause returned'
    );
  }
}
