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

  /**
   * Ensures combine returns expected query
   */
  @IsTest
  static void combine() {
    ASB_SubQuery subQuery1 = ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.FirstName);
    ASB_SubQuery subQuery2 = ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.LastName);
    ASB_SubQuery subQuery3 = ASB_SubQuery.relatedBy(Contact.AccountId);
    Test.startTest();
    ASB_SubQuery actualSubQuery = subQuery1.combine(subQuery2).combine(subQuery3);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, FirstName, LastName FROM Contacts',
      actualSubQuery.soqlString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures combine throws exception if from clauses are different
   */
  @IsTest
  static void combineExceptionFrom() {
    ASB_SubQuery subQuery1 = ASB_SubQuery.relatedBy(Contact.AccountId);
    ASB_SubQuery subQuery2 = ASB_SubQuery.relatedBy(Order.AccountId);
    Test.startTest();
    try {
      subQuery1.combine(subQuery2);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures combine throws exception if recordLimit is set
   */
  @IsTest
  static void combineExceptionLimit() {
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(ASB_SubQuery.relatedBy(Contact.AccountId).recordLimit(10));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).combine(ASB_SubQuery.relatedBy(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).combine(ASB_SubQuery.relatedBy(Contact.AccountId).recordLimit(10));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures combine throws exception if orderBy is set
   */
  @IsTest
  static void combineExceptionOrderBy() {
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(ASB_SubQuery.relatedBy(Contact.AccountId).orderBy(ASB_OrderBy.field(Contact.Id)));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(ASB_OrderBy.field(Contact.Id)).combine(ASB_SubQuery.relatedBy(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(ASB_OrderBy.field(Contact.Id))
        .combine(ASB_SubQuery.relatedBy(Contact.AccountId).orderBy(ASB_OrderBy.field(Contact.Id)));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures combine throws exception if filter is set
   */
  @IsTest
  static void combineExceptionFilter() {
    ASB_SubQuery subQuery = ASB_SubQuery.relatedBy(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(
        ASB_SubQuery.relatedBy(Contact.AccountId).filter(ASB_Where.field(Contact.FirstName).equals().string('test'))
      );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(ASB_Where.field(Contact.FirstName).equals().string('test'))
        .combine(ASB_SubQuery.relatedBy(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(ASB_Where.field(Contact.FirstName).equals().string('test'))
        .combine(
          ASB_SubQuery.relatedBy(Contact.AccountId).filter(ASB_Where.field(Contact.FirstName).equals().string('test'))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }
}
