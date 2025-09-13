/**
 * @description Unit tests for ASB_WhereClause.
 * Ensures correct behavior for SOQL WHERE clause logic.
 * @author Russell Laboe
 */
@isTest
private class ASB_WhereClause_Test {
  private static ASB_BindContext ctx = new ASB_BindContext();

  private static String expectedStr = 'Foo';
  private static List<String> expectedList = new List<String>{ 'Foo', 'Bar' };
  private static Integer expectedInt = 10;
  private static Decimal expectedDec = 5.1;
  private static Date expectedDate = Date.newInstance(2025, 1, 1);
  private static Datetime expectedDateTime = Datetime.newInstance(0);
  private static Boolean expectedBool = false;

  private static List<Schema.SObjectField> nameFieldPath = new List<Schema.SObjectField>{ Account.Name };

  /**
   * Ensures clause is built as expected for eq method calls.
   */
  @IsTest
  static void makeEQ() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedStr }),
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime }),
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => expectedBool })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedStr),
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedDateTime),
      new ASB_WhereClause.FieldComparison(nameFieldPath).eq(expectedBool)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for ne method calls.
   */
  @IsTest
  static void makeNE() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedStr }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => expectedBool })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedStr),
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedDateTime),
      new ASB_WhereClause.FieldComparison(nameFieldPath).ne(expectedBool)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gt method calls.
   */
  @IsTest
  static void makeGT() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).gt(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gt(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gt(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gt(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gte method calls.
   */
  @IsTest
  static void makeGTE() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).gte(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gte(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gte(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).gte(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lt method calls.
   */
  @IsTest
  static void makeLT() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).lt(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lt(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lt(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lt(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lte method calls.
   */
  @IsTest
  static void makeLTE() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).lte(expectedInt),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lte(expectedDec),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lte(expectedDate),
      new ASB_WhereClause.FieldComparison(nameFieldPath).lte(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for other method calls.
   */
  @isTest
  static void makeOther() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => null }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => null }),
      new Expectation('WHERE Name IN :Name1', new Map<String, Object>{ 'Name1' => expectedList }),
      new Expectation('WHERE Name LIKE :Name1', new Map<String, Object>{ 'Name1' => expectedStr })
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause.FieldComparison(nameFieldPath).isNull(),
      new ASB_WhereClause.FieldComparison(nameFieldPath).isNotNull(),
      new ASB_WhereClause.FieldComparison(nameFieldPath).isIn(expectedList),
      new ASB_WhereClause.FieldComparison(nameFieldPath).isLike(expectedStr)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `and` logical group.
   */
  @isTest
  static void andx() {
    ASB_WhereClause clause1 = new ASB_WhereClause.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .eq(expectedStr);
    ASB_WhereClause clause2 = new ASB_WhereClause.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne(expectedStr);
    ASB_WhereClause clause3 = new ASB_WhereClause.FieldComparison(new List<Schema.SObjectField>{ Account.Name })
      .isIn(expectedList);

    Expectation[] expectations = new List<Expectation>{
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1',
        new Map<String, Object>{ 'Owner_LastName1' => expectedStr, 'Owner_Profile_Name1' => expectedStr }
      ),
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1 AND Name IN :Name1',
        new Map<String, Object>{
          'Owner_LastName1' => expectedStr,
          'Owner_Profile_Name1' => expectedStr,
          'Name1' => expectedList
        }
      ),
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1 AND Name IN :Name1 AND Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1',
        new Map<String, Object>{
          'Owner_LastName1' => expectedStr,
          'Owner_Profile_Name1' => expectedStr,
          'Name1' => expectedList
        }
      )
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause(new ASB_WhereClause.AndLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2 })),
      new ASB_WhereClause(new ASB_WhereClause.AndLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2, clause3 })),
      new ASB_WhereClause(
        new ASB_WhereClause.AndLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2, clause3, clause1, clause2 })
      )
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `or` logical group.
   */
  @isTest
  static void orx() {
    ASB_WhereClause clause1 = new ASB_WhereClause.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .eq(expectedStr);
    ASB_WhereClause clause2 = new ASB_WhereClause.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne(expectedStr);
    ASB_WhereClause clause3 = new ASB_WhereClause.FieldComparison(new List<Schema.SObjectField>{ Account.Name })
      .isIn(expectedList);

    Expectation[] expectations = new List<Expectation>{
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1',
        new Map<String, Object>{ 'Owner_LastName1' => expectedStr, 'Owner_Profile_Name1' => expectedStr }
      ),
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1 OR Name IN :Name1',
        new Map<String, Object>{
          'Owner_LastName1' => expectedStr,
          'Owner_Profile_Name1' => expectedStr,
          'Name1' => expectedList
        }
      ),
      new Expectation(
        'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1 OR Name IN :Name1 OR Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1',
        new Map<String, Object>{
          'Owner_LastName1' => expectedStr,
          'Owner_Profile_Name1' => expectedStr,
          'Name1' => expectedList
        }
      )
    };

    ASB_WhereClause[] tests = new List<ASB_WhereClause>{
      new ASB_WhereClause(new ASB_WhereClause.OrLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2 })),
      new ASB_WhereClause(new ASB_WhereClause.OrLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2, clause3 })),
      new ASB_WhereClause(
        new ASB_WhereClause.OrLogicalGroup(new List<ASB_WhereClause>{ clause1, clause2, clause3, clause1, clause2 })
      )
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  static void assertExpectations(Expectation[] expectations, ASB_WhereClause[] tests) {
    System.Assert.areEqual(expectations.size(), tests.size(), 'unexpected number of clauses');
    for (Integer i = 0; i < expectations.size(); i++) {
      expectations[i].test(tests[i]);
    }
  }

  private class Expectation {
    String query;
    Map<String, Object> binds;
    ASB_BindContext ctx = new ASB_BindContext();

    private Expectation(String query, Map<String, Object> binds) {
      this.query = query;
      this.binds = binds;
    }

    private void test(ASB_WhereClause asbWhere) {
      System.Assert.areEqual(this.query, asbWhere.clauseString(ctx), 'unexpected clause returned: ' + this);
      System.Assert.areEqual(this.binds, ctx.getBinds(), 'unexpected binds returned: ' + this);
    }
  }
}
