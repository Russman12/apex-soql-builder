@isTest
public with sharing class ASB_SubQuery_Test {
  //TODO: mock this
  private static ASB asb = new ASB();

  /**
   * Ensures relatedBy method returns expected instance
   */
  @isTest
  static void relatedBy() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectField adds field to SELECT clause
   */
  @isTest
  static void selectField() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId).selectField(Contact.Name);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Name FROM Contacts',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectParentField adds parent field to SELECT clause when given list.
   */
  @isTest
  static void selectParentFieldList() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId)
      .selectParentField(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name });
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Account.Name FROM Contacts',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectParentField adds parent field to SELECT clause when given 2 fields.
   */
  @isTest
  static void selectParentField2() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId).selectParentField(Contact.AccountId, Account.Name);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Account.Name FROM Contacts',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures selectSubQuery adds subquery to SELECT clause.
   */
  @isTest
  static void selectSubQuery() {
    ASB_SubQuery outerSub = new ASB_SubQuery(Contact.AccountId);
    ASB_SubQuery innerSub = new ASB_SubQuery(Case.ContactId);
    Test.startTest();
    outerSub = outerSub.selectSubQuery(innerSub);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, (SELECT Id FROM Cases) FROM Contacts',
      outerSub.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures filter adds WHERE clause to query.
   */
  @isTest
  static void filter() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId).filter(asb.filter().field(Contact.Name).eq('test'));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts WHERE Name = :WHERE_Name1',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures orderBy adds ORDER BY clause to query.
   */
  @isTest
  static void orderBy() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId).orderBy(asb.orderByfield(Contact.Name));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts ORDER BY Name',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures recordLimit adds LIMIT clause to query.
   */
  @isTest
  static void recordLimit() {
    Test.startTest();
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId).recordLimit(10);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts LIMIT :RECORD_LIMIT',
      subQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures combine returns expected query
   */
  @IsTest
  static void combine() {
    ASB_SubQuery subQuery1 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.FirstName);
    ASB_SubQuery subQuery2 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.LastName);
    ASB_SubQuery subQuery3 = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    ASB_SubQuery actualSubQuery = subQuery1.combine(subQuery2).combine(subQuery3);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, FirstName, LastName FROM Contacts',
      actualSubQuery.queryDetail().getQueryString(),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures combine throws exception if from clauses are different
   */
  @IsTest
  static void combineExceptionFrom() {
    ASB_SubQuery subQuery1 = new ASB_SubQuery(Contact.AccountId);
    ASB_SubQuery subQuery2 = new ASB_SubQuery(Order.AccountId);
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
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(new ASB_SubQuery(Contact.AccountId).recordLimit(10));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).combine(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).combine(new ASB_SubQuery(Contact.AccountId).recordLimit(10));
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
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(new ASB_SubQuery(Contact.AccountId).orderBy(asb.orderByfield(Contact.Id)));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id)).combine(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id))
        .combine(new ASB_SubQuery(Contact.AccountId).orderBy(asb.orderByfield(Contact.Id)));
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
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.combine(new ASB_SubQuery(Contact.AccountId).filter(asb.filter().field(Contact.FirstName).eq('test')));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test')).combine(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test'))
        .combine(new ASB_SubQuery(Contact.AccountId).filter(asb.filter().field(Contact.FirstName).eq('test')));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }
}
