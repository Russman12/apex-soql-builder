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
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedStr }),
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime }),
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedBool })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedStr).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedDateTime).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).eq(expectedBool).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for ne method calls
   */
  @IsTest
  static void makeNE() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedStr }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedBool })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedStr).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedDateTime).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).ne(expectedBool).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gt method calls
   */
  @IsTest
  static void makeGT() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name > :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name > :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name > :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name > :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gt(expectedDateTime).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for gte method calls
   */
  @IsTest
  static void makeGTE() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name >= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name >= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name >= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name >= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).gte(expectedDateTime).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lt method calls
   */
  @IsTest
  static void makeLT() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name < :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name < :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name < :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name < :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lt(expectedDateTime).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for lte method calls
   */
  @IsTest
  static void makeLTE() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name <= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedInt }),
      new ASB_ClauseDetail('WHERE Name <= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDec }),
      new ASB_ClauseDetail('WHERE Name <= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDate }),
      new ASB_ClauseDetail('WHERE Name <= :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedDateTime })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedInt).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDec).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDate).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).lte(expectedDateTime).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  /**
   * Ensures clause is built as expected for other method calls
   */
  @isTest
  static void makeOther() {
    ASB_ClauseDetail[] expectedClauses = new List<ASB_ClauseDetail>{
      new ASB_ClauseDetail('WHERE Name = :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => null }),
      new ASB_ClauseDetail('WHERE Name != :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => null }),
      new ASB_ClauseDetail('WHERE Name IN :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedList }),
      new ASB_ClauseDetail('WHERE Name LIKE :WHERE_Name1', new Map<String, Object>{ 'WHERE_Name1' => expectedStr })
    };

    ASB_ClauseDetail[] actualClauses = new List<ASB_ClauseDetail>{
      new ASB_Where.FieldComparison(nameFieldPath).isNull().clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).isNotNull().clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).isIn(expectedList).clauseDetail(),
      new ASB_Where.FieldComparison(nameFieldPath).isLike(expectedStr).clauseDetail()
    };

    Test.startTest();
    assertDetails(expectedClauses, actualClauses);
    Test.stopTest();
  }

  static void assertDetails(ASB_ClauseDetail[] expectedClauses, ASB_ClauseDetail[] actualClauses) {
    System.Assert.areEqual(expectedClauses.size(), actualClauses.size(), 'unexpected number of ASB_ClauseDetails');
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(
        expectedClauses[i].getClauseString(),
        actualClauses[i].getClauseString(),
        'unexpected clause returned. idx: ' + i
      );
      System.Assert.areEqual(
        expectedClauses[i].getBindings(),
        actualClauses[i].getBindings(),
        'unexpected bindings returned. idx: ' + i
      );
    }
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
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 AND Owner.Profile.Name != :WHERE_Owner_Profile_Name1',
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 AND Owner.Profile.Name != :WHERE_Owner_Profile_Name1 AND Name IN :WHERE_Name1',
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 AND Owner.Profile.Name != :WHERE_Owner_Profile_Name1 AND Name IN :WHERE_Name1 AND Owner.LastName = :WHERE_Owner_LastName2 AND Owner.Profile.Name != :WHERE_Owner_Profile_Name2'
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2 }))
        .clauseDetail()
        .getClauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 }))
        .clauseDetail()
        .getClauseString(),
      new ASB_Where(new ASB_Where.AndLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseDetail()
        .getClauseString()
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
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 OR Owner.Profile.Name != :WHERE_Owner_Profile_Name1',
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 OR Owner.Profile.Name != :WHERE_Owner_Profile_Name1 OR Name IN :WHERE_Name1',
      'WHERE Owner.LastName = :WHERE_Owner_LastName1 OR Owner.Profile.Name != :WHERE_Owner_Profile_Name1 OR Name IN :WHERE_Name1 OR Owner.LastName = :WHERE_Owner_LastName2 OR Owner.Profile.Name != :WHERE_Owner_Profile_Name2'
    };

    String[] actualClauses = new List<String>{
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2 }))
        .clauseDetail()
        .getClauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3 }))
        .clauseDetail()
        .getClauseString(),
      new ASB_Where(new ASB_Where.OrLogicalGroup(new List<ASB_Where>{ clause1, clause2, clause3, clause1, clause2 }))
        .clauseDetail()
        .getClauseString()
    };

    Test.startTest();
    for (Integer i = 0; i < expectedClauses.size(); i++) {
      System.Assert.areEqual(expectedClauses[i], actualClauses[i], 'unexpected clause returned. idx: ' + i);
    }
    Test.stopTest();
  }
}
