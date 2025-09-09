/**
 * Provides unit test coverage for ASB_Where class
 * @author Russell Laboe
 */
@isTest
private class ASB_Where_Test {
  private static String expectedStr = 'Foo';
  private static List<String> expectedList = new List<String>{ 'Foo', 'Bar' };
  private static Integer expectedInt = 10;
  private static Decimal expectedDec = 5.1;
  private static Date expectedDate = Date.newInstance(2025, 1, 1);
  private static Datetime expectedDateTime = Datetime.newInstance(0);
  private static Boolean expectedBool = false;

  private static List<Schema.SObjectField> nameFieldPath = new List<Schema.SObjectField>{ Account.Name };

  /**
   * Ensures clause is built as expected for eq method calls
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

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedStr),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDateTime),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedBool)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for ne method calls
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

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedStr),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDateTime),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedBool)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gt method calls
   */
  @IsTest
  static void makeGT() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name > :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gte method calls
   */
  @IsTest
  static void makeGTE() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name >= :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lt method calls
   */
  @IsTest
  static void makeLT() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name < :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lte method calls
   */
  @IsTest
  static void makeLTE() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedInt }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDec }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDate }),
      new Expectation('WHERE Name <= :Name1', new Map<String, Object>{ 'Name1' => expectedDateTime })
    };

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedInt),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDec),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDate),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDateTime)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for other method calls
   */
  @isTest
  static void makeOther() {
    Expectation[] expectations = new List<Expectation>{
      new Expectation('WHERE Name = :Name1', new Map<String, Object>{ 'Name1' => null }),
      new Expectation('WHERE Name != :Name1', new Map<String, Object>{ 'Name1' => null }),
      new Expectation('WHERE Name IN :Name1', new Map<String, Object>{ 'Name1' => expectedList }),
      new Expectation('WHERE Name LIKE :Name1', new Map<String, Object>{ 'Name1' => expectedStr })
    };

    ASB_Where[] tests = new List<ASB_Where>{
      new ASB_Where.FieldComparison(nameFieldPath).isNull(),
      new ASB_Where.FieldComparison(nameFieldPath).isNotNull(),
      new ASB_Where.FieldComparison(nameFieldPath).isIn(expectedList),
      new ASB_Where.FieldComparison(nameFieldPath).isLike(expectedStr)
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `and` logical group
   */
  @isTest
  static void andx() {
    ASB_Where clause1 = new ASB_Where.FieldComparison(new List<Schema.SObjectField>{ Account.OwnerId, User.LastName })
      .eq(expectedStr);
    ASB_Where clause2 = new ASB_Where.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne(expectedStr);
    ASB_Where clause3 = new ASB_Where.FieldComparison(new List<Schema.SObjectField>{ Account.Name }).isIn(expectedList);

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1',
      'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1 AND Name IN :Name1',
      'WHERE Owner.LastName = :Owner_LastName1 AND Owner.Profile.Name != :Owner_Profile_Name1 AND Name IN :Name1 AND Owner.LastName = :Owner_LastName2 AND Owner.Profile.Name != :Owner_Profile_Name2'
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2 })).clauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 })).clauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected when given `or` logical group
   */
  @isTest
  static void orx() {
    ASB_Where clause1 = new ASB_Where.FieldComparison(new List<Schema.SObjectField>{ Account.OwnerId, User.LastName })
      .eq('Foo');
    ASB_Where clause2 = new ASB_Where.FieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne('Foo');
    ASB_Where clause3 = new ASB_Where.FieldComparison(new List<Schema.SObjectField>{ Account.Name })
      .isIn(new List<String>{ 'Foo', 'Bar' });

    String[] expectedClauses = new List<String>{
      'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1',
      'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1 OR Name IN :Name1',
      'WHERE Owner.LastName = :Owner_LastName1 OR Owner.Profile.Name != :Owner_Profile_Name1 OR Name IN :Name1 OR Owner.LastName = :Owner_LastName2 OR Owner.Profile.Name != :Owner_Profile_Name2'
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2 })).clauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 })).clauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }

  static void assertExpectations(Expectation[] expectations, ASB_Where[] tests) {
    System.Assert.areEqual(expectations.size(), tests.size(), 'unexpected number of clauses');
    for (Integer i = 0; i < expectations.size(); i++) {
      expectations[i].test(tests[i]);
    }
  }

  private class Expectation {
    String query;
    Map<String, Object> binds;

    private Expectation(String query, Map<String, Object> binds) {
      this.query = query;
      this.binds = binds;
    }

    private void test(ASB_Where asbWhere) {
      System.Assert.areEqual(asbWhere.clauseString(), this.query, 'unexpected clause returned: ' + this);
      System.Assert.areEqual(asbWhere.getBinds(), this.binds, 'unexpected binds returned: ' + this);
    }
  }
}
