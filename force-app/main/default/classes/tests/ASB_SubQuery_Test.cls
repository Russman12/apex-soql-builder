@isTest
public with sharing class ASB_SubQuery_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

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

    System.Assert.areEqual('SELECT Id FROM Contacts', subQuery.queryDetail(ctx), 'Unexpected soql string returned');
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
      subQuery.queryDetail(ctx),
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
      subQuery.queryDetail(ctx),
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
      subQuery.queryDetail(ctx),
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
      outerSub.queryDetail(ctx),
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
      'SELECT Id FROM Contacts WHERE Name = :Contacts_Name1',
      subQuery.queryDetail(ctx),
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
      subQuery.queryDetail(ctx),
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
      'SELECT Id FROM Contacts LIMIT :RECORD_LIMIT1',
      subQuery.queryDetail(ctx),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures mergeInto returns expected query
   */
  @IsTest
  static void mergeInto() {
    ASB_SubQuery subQuery1 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.FirstName);
    ASB_SubQuery subQuery2 = new ASB_SubQuery(Contact.AccountId).selectField(Contact.LastName);
    ASB_SubQuery subQuery3 = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    ASB_SubQuery actualSubQuery = subQuery1.mergeInto(subQuery2).mergeInto(subQuery3);
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, LastName, FirstName FROM Contacts',
      actualSubQuery.queryDetail(ctx),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures mergeInto throws exception if from clauses are different
   */
  @IsTest
  static void mergeIntoExceptionFrom() {
    ASB_SubQuery subQuery1 = new ASB_SubQuery(Contact.AccountId);
    ASB_SubQuery subQuery2 = new ASB_SubQuery(Order.AccountId);
    Test.startTest();
    try {
      subQuery1.mergeInto(subQuery2);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if recordLimit is set
   */
  @IsTest
  static void mergeIntoExceptionLimit() {
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.mergeInto(new ASB_SubQuery(Contact.AccountId).recordLimit(10));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).mergeInto(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.recordLimit(10).mergeInto(new ASB_SubQuery(Contact.AccountId).recordLimit(10));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if orderBy is set
   */
  @IsTest
  static void mergeIntoExceptionOrderBy() {
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.mergeInto(new ASB_SubQuery(Contact.AccountId).orderBy(asb.orderByfield(Contact.Id)));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id)).mergeInto(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id))
        .mergeInto(new ASB_SubQuery(Contact.AccountId).orderBy(asb.orderByfield(Contact.Id)));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if filter is set
   */
  @IsTest
  static void mergeIntoExceptionFilter() {
    ASB_SubQuery subQuery = new ASB_SubQuery(Contact.AccountId);
    Test.startTest();
    try {
      subQuery.mergeInto(new ASB_SubQuery(Contact.AccountId).filter(asb.filter().field(Contact.FirstName).eq('test')));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test')).mergeInto(new ASB_SubQuery(Contact.AccountId));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test'))
        .mergeInto(new ASB_SubQuery(Contact.AccountId).filter(asb.filter().field(Contact.FirstName).eq('test')));
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(e, ASB_SubQuery.InvalidCombineException.class, 'unexpected exception thrown');
    }
    Test.stopTest();
  }
}
