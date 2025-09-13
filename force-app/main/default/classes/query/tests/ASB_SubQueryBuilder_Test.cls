@isTest
public with sharing class ASB_SubQueryBuilder_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  //TODO: mock this
  private static ASB asb = new ASB();

  /**
   * Ensures relatedBy method returns expected instance
   */
  @isTest
  static void relatedBy() {
    Test.startTest();
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    Test.stopTest();

    System.Assert.areEqual('SELECT Id FROM Contacts', subQuery.queryDetail(ctx), 'Unexpected soql string returned');
  }

  /**
   * Ensures selectField adds field to SELECT clause
   */
  @isTest
  static void selectField() {
    Test.startTest();
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .selection(new ASB_SubSelectClause(null).field(Contact.Name));
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
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .selection(
        new ASB_SubSelectClause(null).parent(new List<Schema.SObjectField>{ Contact.AccountId, Account.Name })
      );
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
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .selection(new ASB_SubSelectClause(null).parent(Contact.AccountId, Account.Name));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id, Account.Name FROM Contacts',
      subQuery.queryDetail(ctx),
      'Unexpected soql string returned'
    );
  }

  /**
   * Ensures filter adds WHERE clause to query.
   */
  @isTest
  static void filter() {
    Test.startTest();
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .filter(asb.filter().field(Contact.Name).eq('test'));
    Test.stopTest();

    System.Assert.areEqual(
      'SELECT Id FROM Contacts WHERE Name = :Name1',
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
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .orderBy(asb.orderByfield(Contact.Name));
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
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
        new ASB_FromRelationshipClause(Contact.AccountId),
        new ASB_SubSelectClause(null)
      )
      .recordLimit(10);
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
    ASB_SubQueryBuilder subQuery1 = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null).field(Contact.FirstName)
    );
    ASB_SubQueryBuilder subQuery2 = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null).field(Contact.LastName)
    );
    ASB_SubQueryBuilder subQuery3 = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    Test.startTest();
    ASB_SubQueryBuilder actualSubQuery = subQuery1.mergeInto(subQuery2).mergeInto(subQuery3);
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
    ASB_SubQueryBuilder subQuery1 = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    ASB_SubQueryBuilder subQuery2 = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Order.AccountId),
      asb.subSelection()
    );
    Test.startTest();
    try {
      subQuery1.mergeInto(subQuery2);
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if recordLimit is set
   */
  @IsTest
  static void mergeIntoExceptionLimit() {
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    Test.startTest();
    try {
      subQuery.mergeInto(
        new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
          .recordLimit(10)
      );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.recordLimit(10)
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.recordLimit(10)
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
            .recordLimit(10)
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if orderBy is set
   */
  @IsTest
  static void mergeIntoExceptionOrderBy() {
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    Test.startTest();
    try {
      subQuery.mergeInto(
        new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
          .orderBy(asb.orderByfield(Contact.Id))
      );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id))
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.orderBy(asb.orderByfield(Contact.Id))
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
            .orderBy(asb.orderByfield(Contact.Id))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }
    Test.stopTest();
  }

  /**
   * Ensures mergeInto throws exception if filter is set
   */
  @IsTest
  static void mergeIntoExceptionFilter() {
    ASB_SubQueryBuilder subQuery = new ASB_SubQueryBuilder(
      new ASB_FromRelationshipClause(Contact.AccountId),
      new ASB_SubSelectClause(null)
    );
    Test.startTest();
    try {
      subQuery.mergeInto(
        new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
          .filter(asb.filter().field(Contact.FirstName).eq('test'))
      );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test'))
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }

    try {
      subQuery.filter(asb.filter().field(Contact.FirstName).eq('test'))
        .mergeInto(
          new ASB_SubQueryBuilder(new ASB_FromRelationshipClause(Contact.AccountId), new ASB_SubSelectClause(null))
            .filter(asb.filter().field(Contact.FirstName).eq('test'))
        );
      System.Assert.fail('expected exception not thrown');
    } catch (Exception e) {
      System.Assert.isInstanceOfType(
        e,
        ASB_SubQueryBuilder.InvalidCombineException.class,
        'unexpected exception thrown'
      );
    }
    Test.stopTest();
  }
}
