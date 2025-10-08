/*
Apex SOQL Builder - A type safe dynamic query executor.   Copyright (C) 2025  Russell Laboe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/**
 * @description Unit tests for ASB_WhereClause.
 */
@isTest
private class ASB_Filter_Test {
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedStr)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedDateTime)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).eq(expectedBool))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedStr)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedDateTime)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).ne(expectedBool))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gt(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gt(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gt(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gt(expectedDateTime))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gte(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gte(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gte(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).gte(expectedDateTime))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lt(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lt(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lt(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lt(expectedDateTime))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lte(expectedInt)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lte(expectedDec)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lte(expectedDate)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).lte(expectedDateTime))
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).isNull()),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).notNull()),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).isIn(expectedList)),
      new ASB_Filter(new ASB_FilterFieldComparison(nameFieldPath).isLike(expectedStr))
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
    ASB_FilterField clause1 = new ASB_FilterFieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .eq(expectedStr);
    ASB_FilterField clause2 = new ASB_FilterFieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne(expectedStr);
    ASB_FilterField clause3 = new ASB_FilterFieldComparison(new List<Schema.SObjectField>{ Account.Name })
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(
        new ASB_FilterLogicalGroup(new List<ASB_FilterExpression>{ clause1, clause2 }, ASB_FilterLogicalGroup.AND_OP)
      ),
      new ASB_Filter(
        new ASB_FilterLogicalGroup(
          new List<ASB_FilterExpression>{ clause1, clause2, clause3 },
          ASB_FilterLogicalGroup.AND_OP
        )
      ),
      new ASB_Filter(
        new ASB_FilterLogicalGroup(
          new List<ASB_FilterExpression>{ clause1, clause2, clause3, clause1, clause2 },
          ASB_FilterLogicalGroup.AND_OP
        )
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
    ASB_FilterField clause1 = new ASB_FilterFieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.LastName }
      )
      .eq(expectedStr);
    ASB_FilterField clause2 = new ASB_FilterFieldComparison(
        new List<Schema.SObjectField>{ Account.OwnerId, User.ProfileId, Profile.Name }
      )
      .ne(expectedStr);
    ASB_FilterField clause3 = new ASB_FilterFieldComparison(new List<Schema.SObjectField>{ Account.Name })
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

    ASB_Filter[] tests = new List<ASB_Filter>{
      new ASB_Filter(
        new ASB_FilterLogicalGroup(new List<ASB_FilterExpression>{ clause1, clause2 }, ASB_FilterLogicalGroup.OR_OP)
      ),
      new ASB_Filter(
        new ASB_FilterLogicalGroup(
          new List<ASB_FilterExpression>{ clause1, clause2, clause3 },
          ASB_FilterLogicalGroup.OR_OP
        )
      ),
      new ASB_Filter(
        new ASB_FilterLogicalGroup(
          new List<ASB_FilterExpression>{ clause1, clause2, clause3, clause1, clause2 },
          ASB_FilterLogicalGroup.OR_OP
        )
      )
    };

    Test.startTest();
    assertExpectations(expectations, tests);
    Test.stopTest();
  }

  static void assertExpectations(Expectation[] expectations, ASB_Filter[] tests) {
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

    private void test(ASB_Filter filter) {
      System.Assert.areEqual(this.query, filter.clauseString(ctx), 'unexpected clause returned: ' + this);
      System.Assert.areEqual(this.binds, ctx.getBinds(), 'unexpected binds returned: ' + this);
    }
  }
}
