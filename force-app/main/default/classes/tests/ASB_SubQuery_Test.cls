@isTest
public with sharing class ASB_SubQuery_Test {
  /**
   * Ensures relatedBy method returns expected instance
   */
  @isTest
  static void relatedBy() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id FROM Contacts', subQuery.soqlString(), 'Unexpected soql string returned');
  }

  /**
   * Ensures selectField adds field to SELECT clause
   */
  @isTest
  static void selectField() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.Name);
    Test.stopTest();

    System.Assert.areEqual('SELECT Id, Name FROM Contacts', subQuery.soqlString(), 'Unexpected soql string returned');
  }

  /**
   * Ensures selectParentField adds parent field to SELECT clause when given list.
   */
  @isTest
  static void selectParentFieldList() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId)
      .selectParentField(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Account.Name FROM Contacts',
      subQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectParentField adds parent field to SELECT clause when given 2 fields.
   */
  @isTest
  static void selectParentField2() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId)
      .selectParentField(Contact.AccountId, Account.Name);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Account.Name FROM Contacts',
      subQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectSubQuery adds subquery to SELECT clause.
   */
  @isTest
  static void selectSubQuery() {
    ASB_SubQuery outerSub = ASB_SubQuery.relatedBy(Contact.AccountId);
    ASB_SubQuery innerSub = ASB_SubQuery.relatedBy(Case.ContactId);
    Test.startTest();
    outerSub = outerSub.selectSubQuery(innerSub);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, (SELECT Id FROM Cases) FROM Contacts',
      outerSub.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures filter adds WHERE clause to query.
   */
  @isTest
  static void filter() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId)
      .filter(ASB_Where.field(Contact.Name).equals().string('test'));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts WHERE Name = \'test\'',
      subQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures orderBy adds ORDER BY clause to query.
   */
  @isTest
  static void orderBy() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId).orderBy(ASB_OrderBy.field(Contact.Name));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts ORDER BY Name',
      subQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures recordLimit adds LIMIT clause to query.
   */
  @isTest
  static void recordLimit() {
    Test.startTest();
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId).recordLimit(10);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts LIMIT 10',
      subQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }
}
